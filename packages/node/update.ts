import { $ } from "bun";
import { cp, mkdir, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const registry = "https://registry.npmjs.org";

type Package = {
  attrName: string;
  pname: string;
  npmName: string;
  version: string;
  hash: string;
  npmDepsHash: string;
};

function die(message: string): never {
  throw new Error(`update.ts: ${message}`);
}

function parseArgs(args: string[]): {
  force: boolean;
  requestedVersions: Map<string, string>;
} {
  let force = false;
  const requestedVersions = new Map<string, string>();
  for (const arg of args) {
    if (arg === "--force") {
      force = true;
      continue;
    }
    if (arg.startsWith("--")) {
      die(`unknown argument: ${arg}`);
    }

    const separator = arg.lastIndexOf("@");
    if (separator <= 0 || separator === arg.length - 1) {
      die(`expected <npmName>@<version>, got: ${arg}`);
    }
    const npmName = arg.slice(0, separator);
    const version = arg.slice(separator + 1);
    if (requestedVersions.has(npmName)) {
      die(`duplicate package argument: ${npmName}`);
    }
    requestedVersions.set(npmName, version);
  }
  return { force, requestedVersions };
}

const blockRe =
  /^ {2}([A-Za-z_][A-Za-z0-9_'-]*) = mkNpmPackage \{\n[\s\S]*?^ {2}\};/gm;

function getField(block: string, name: string): string | undefined {
  return block.match(new RegExp(`^ {4}${name} = "(.*)";$`, "m"))?.[1];
}

function setField(block: string, name: string, value: string): string {
  const re = new RegExp(`^( {4}${name} = ").*(";)$`, "m");
  if (!re.test(block)) die(`field not found: ${name}`);
  return block.replace(re, (_, prefix, suffix) => prefix + value + suffix);
}

function parsePackages(nixText: string): Package[] {
  const packages = [...nixText.matchAll(blockRe)].map(([block, attrName]) => {
    const field = (name: string) =>
      getField(block, name) ?? die(`missing ${name} in ${attrName}`);
    const pname = field("pname");
    if (!/^[A-Za-z0-9._+-]+$/.test(pname)) {
      die(`unsupported pname for path generation in ${attrName}: ${pname}`);
    }
    return {
      attrName,
      pname,
      npmName: getField(block, "npmName") ?? pname,
      version: field("version"),
      hash: field("hash"),
      npmDepsHash: field("npmDepsHash"),
    };
  });

  if (packages.length === 0) die("no mkNpmPackage blocks found");
  return packages;
}

async function updatePackage(
  pkg: Package,
  version: string,
  workDir: string,
  prefetchNpmDeps: string,
): Promise<Package> {
  console.log(
    `\nUpdating ${pkg.attrName} (${pkg.npmName}) from ${pkg.version} to ${version}`,
  );

  const tarballUrl = `${registry}/${pkg.npmName}/-/${pkg.pname}-${version}.tgz`;
  console.log(`  prefetching source: ${tarballUrl}`);
  const prefetch =
    await $`nix store prefetch-file --json --unpack ${tarballUrl}`.json();
  if (
    typeof prefetch.hash !== "string" ||
    typeof prefetch.storePath !== "string"
  ) {
    die(`unexpected prefetch output for ${pkg.pname}`);
  }

  const sourceDir = join(workDir, pkg.pname);
  await cp(prefetch.storePath, sourceDir, { recursive: true });
  await $`chmod -R u+w ${sourceDir}`;

  console.log("  generating package-lock.json");
  await $`npm install --package-lock-only`.cwd(sourceDir);

  console.log("  prefetching npm dependencies");
  const npmDepsHash = (
    await $`${prefetchNpmDeps} ${join(sourceDir, "package-lock.json")}`.text()
  ).trim();
  if (npmDepsHash.length === 0)
    die(`failed to compute npmDepsHash for ${pkg.pname}`);

  console.log(`  source hash: ${prefetch.hash}`);
  console.log(`  npmDepsHash: ${npmDepsHash}`);
  return { ...pkg, version, hash: prefetch.hash, npmDepsHash };
}

async function main(): Promise<void> {
  $.throws(true);
  const { force, requestedVersions } = parseArgs(process.argv.slice(2));

  const scriptDir = dirname(fileURLToPath(import.meta.url));
  const repoRoot = (
    await $`git -C ${scriptDir} rev-parse --show-toplevel`.text()
  ).trim();
  const nodeDir = join(repoRoot, "packages", "node");
  const defaultNix = join(nodeDir, "default.nix");

  const tmpRoot = await mkdtemp(join(tmpdir(), "packages-node-update-"));
  try {
    const npmrc = join(tmpRoot, "npmrc");
    await writeFile(npmrc, `registry=${registry}/\nignore-scripts=true\n`);
    $.env({
      ...process.env,
      XDG_CACHE_HOME: join(tmpRoot, "xdg-cache"),
      NPM_CONFIG_CACHE: join(tmpRoot, "npm-cache"),
      NPM_CONFIG_USERCONFIG: npmrc,
    });

    const nixText = await readFile(defaultNix, "utf8");
    const packages = parsePackages(nixText);
    console.log(`Found ${packages.length} package(s) in ${defaultNix}`);

    for (const npmName of requestedVersions.keys()) {
      if (!packages.some((pkg) => pkg.npmName === npmName)) {
        die(`package not found in ${defaultNix}: ${npmName}`);
      }
    }
    const targets =
      requestedVersions.size === 0
        ? packages
        : packages.filter((pkg) => requestedVersions.has(pkg.npmName));

    const versions = new Map<string, string>();
    for (const pkg of targets) {
      console.log(
        `\nChecking ${pkg.attrName} (${pkg.npmName}), current version ${pkg.version}`,
      );
      const requestedVersion = requestedVersions.get(pkg.npmName);
      const spec =
        requestedVersion === undefined
          ? pkg.npmName
          : `${pkg.npmName}@${requestedVersion}`;
      const version = await $`npm view ${spec} version --json`.json();
      if (typeof version !== "string" || version.length === 0) {
        die(`npm view did not return a version string for ${spec}`);
      }
      if (requestedVersion !== undefined && version !== requestedVersion) {
        die(`requested version did not resolve exactly: ${spec} -> ${version}`);
      }
      console.log(
        requestedVersion === undefined
          ? `  latest version: ${version}`
          : `  requested version: ${version}`,
      );

      if (!force && version === pkg.version) {
        console.log("  already up to date; skipping");
        continue;
      }

      if (!force && requestedVersion === undefined) {
        let order: number;
        try {
          order = Bun.semver.order(version, pkg.version);
        } catch (error) {
          die(
            `failed to compare versions for ${pkg.npmName} (${version} vs ${pkg.version}): ${
              error instanceof Error ? error.message : String(error)
            }`,
          );
        }
        if (order <= 0) {
          console.log(
            `  latest (${version}) is not newer than current (${pkg.version}); skipping (use --force to override)`,
          );
          continue;
        }
      }

      versions.set(pkg.attrName, version);
    }

    if (versions.size === 0) {
      console.log("\nNo package updates needed.");
      return;
    }

    const prefetchNpmDeps = join(
      (
        await $`nix build --inputs-from ${repoRoot} nixpkgs#prefetch-npm-deps --no-link --print-out-paths`.text()
      ).trim(),
      "bin",
      "prefetch-npm-deps",
    );

    const workDir = join(tmpRoot, "work");
    await mkdir(workDir);

    const updated = new Map<string, Package>();
    for (const pkg of packages) {
      const version = versions.get(pkg.attrName);
      if (version === undefined) continue;
      updated.set(
        pkg.attrName,
        await updatePackage(pkg, version, workDir, prefetchNpmDeps),
      );
    }

    console.log("\nWriting updates");
    for (const pkg of updated.values()) {
      const packageDir = join(nodeDir, pkg.pname);
      await mkdir(packageDir, { recursive: true });
      await cp(
        join(workDir, pkg.pname, "package-lock.json"),
        join(packageDir, "package-lock.json"),
      );
    }
    const newText = nixText.replace(blockRe, (block, attrName: string) => {
      const pkg = updated.get(attrName);
      if (pkg === undefined) return block;
      return setField(
        setField(setField(block, "version", pkg.version), "hash", pkg.hash),
        "npmDepsHash",
        pkg.npmDepsHash,
      );
    });
    await writeFile(defaultNix, newText);

    console.log(`Updated ${updated.size} package(s).`);
  } finally {
    await rm(tmpRoot, { recursive: true, force: true });
  }
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  if (error && typeof error === "object" && "stderr" in error && error.stderr) {
    process.stderr.write(String(error.stderr));
  }
  process.exit(1);
});
