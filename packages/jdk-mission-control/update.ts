import { $ } from "bun";
import { readFile, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const platform = "macos-aarch64";
const indexUrl = "https://jdk.java.net/jmc/";
// Some CDNs reject the default User-Agent.
const userAgent =
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36";

function die(message: string): never {
  throw new Error(`update.ts: ${message}`);
}

async function fetchText(url: string): Promise<string> {
  const res = await fetch(url, { headers: { "user-agent": userAgent } });
  if (!res.ok) die(`GET ${url} -> HTTP ${res.status}`);
  return res.text();
}

function readField(text: string, name: string): string {
  const matches = [
    ...text.matchAll(new RegExp(`^\\s*${name} = "([^"]*)";$`, "gm")),
  ];
  if (matches.length !== 1) {
    die(
      `expected exactly one '${name}' field in package.nix, found ${matches.length}`,
    );
  }
  return matches[0][1];
}

function setField(text: string, name: string, value: string): string {
  let count = 0;
  const out = text.replace(
    new RegExp(`^(\\s*${name} = ")[^"]*(";)$`, "gm"),
    (_match, prefix, suffix) => {
      count += 1;
      return prefix + value + suffix;
    },
  );
  if (count !== 1) {
    die(`expected exactly one '${name}' field in package.nix, found ${count}`);
  }
  return out;
}

async function latestMajor(): Promise<number> {
  const html = await fetchText(indexUrl);
  const majors = [...html.matchAll(/jmc\/(\d+)\b/g)].map((m) => Number(m[1]));
  if (majors.length === 0) die(`no jmc/<major> link found on ${indexUrl}`);
  return Math.max(...majors);
}

type Release = { url: string; version: string; build: string };

async function latestRelease(major: number): Promise<Release> {
  const pageUrl = `${indexUrl}${major}/`;
  const html = await fetchText(pageUrl);
  // The negative lookahead skips .tar.gz.sha256 links.
  const re = new RegExp(
    `https://download\\.java\\.net/java/GA/jmc\\d+/(\\d+)/binaries/jmc-([0-9][0-9A-Za-z.-]*)_${platform}\\.tar\\.gz(?!\\.)`,
    "g",
  );
  const byUrl = new Map<string, Release>();
  for (const m of html.matchAll(re)) {
    byUrl.set(m[0], { url: m[0], build: m[1], version: m[2] });
  }
  const releases = [...byUrl.values()];
  if (releases.length === 0) {
    die(`no ${platform} tarball found on ${pageUrl}`);
  }
  const [first] = releases;
  for (const r of releases) {
    if (r.version !== first.version || r.build !== first.build) {
      die(`conflicting ${platform} releases on ${pageUrl}`);
    }
  }
  return first;
}

async function main(): Promise<void> {
  $.throws(true);

  let force = false;
  for (const arg of process.argv.slice(2)) {
    if (arg === "--force") force = true;
    else die(`unknown argument: ${arg}`);
  }

  const scriptDir = dirname(fileURLToPath(import.meta.url));
  const packageNix = join(scriptDir, "package.nix");
  const text = await readFile(packageNix, "utf8");
  const current = {
    version: readField(text, "version"),
    build: readField(text, "build"),
    hash: readField(text, "hash"),
  };
  console.log(
    `Current: ${current.version} (build ${current.build})\n  ${current.hash}`,
  );

  const major = await latestMajor();
  const release = await latestRelease(major);
  console.log(`Latest:  ${release.version} (build ${release.build})`);

  if (!force) {
    if (
      release.version === current.version &&
      release.build === current.build
    ) {
      console.log("Already up to date; skipping (use --force to re-fetch).");
      return;
    }
    if (
      release.version !== current.version &&
      Bun.semver.order(release.version, current.version) < 0
    ) {
      console.log(
        `Latest (${release.version}) is not newer than current (${current.version}); skipping (use --force to override).`,
      );
      return;
    }
  }

  console.log(`\nPrefetching ${release.url}`);
  const prefetch =
    await $`nix store prefetch-file --json ${release.url}`.json();
  if (typeof prefetch.hash !== "string" || prefetch.hash.length === 0) {
    die("nix store prefetch-file did not return a hash");
  }
  console.log(`  hash: ${prefetch.hash}`);

  const updated = setField(
    setField(
      setField(text, "version", release.version),
      "build",
      release.build,
    ),
    "hash",
    prefetch.hash,
  );
  if (updated === text) {
    console.log("\nNo changes to write.");
    return;
  }
  await writeFile(packageNix, updated);
  console.log(
    `\nUpdated package.nix to ${release.version} (build ${release.build}).`,
  );
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  if (error && typeof error === "object" && "stderr" in error && error.stderr) {
    process.stderr.write(String(error.stderr));
  }
  process.exit(1);
});
