{
  pkgs,
}:
let
  inherit (pkgs) buildNpmPackage fetchzip;

  mkNpmPackage =
    {
      pname,
      npmName ? pname,
      version,
      hash,
      npmDepsHash,
      description,
      homepage,
      extraPostPatch ? "",
    }:
    buildNpmPackage {
      inherit pname version npmDepsHash;

      src = fetchzip {
        url = "https://registry.npmjs.org/${npmName}/-/${pname}-${version}.tgz";
        inherit hash;
      };

      postPatch = ''
        cp ${./${pname}/package-lock.json} package-lock.json
        mkdir -p node_modules
      ''
      + extraPostPatch;

      dontNpmBuild = true;

      npmPackFlags = [ "--ignore-scripts" ];

      meta = {
        inherit description homepage;
        mainProgram = pname;
      };
    };
in
{
  chrome-devtools-mcp = mkNpmPackage {
    pname = "chrome-devtools-mcp";
    version = "1.10.1";
    hash = "sha256-uFu8/2L0JySGGP+1X5+rT0QyfCq28OMLnhDF4jyLEAY=";
    npmDepsHash = "sha256-nH9eYyn37PMq2yS9PW/r1ob5zfzdRRfZHJuov0kXGF4=";
    description = "Chrome DevTools MCP server and CLI";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    extraPostPatch = ''
      substituteInPlace build/src/config/mcp-options.js \
        --replace-fail "args.channel = 'stable';" "args.channel = args.autoConnect ? 'stable' : 'beta';"
    '';
  };
}
