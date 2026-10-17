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
    version = "1.11.0";
    hash = "sha256-L67t60i3zUKlZmn6uh9SlJh2B2nC+iQIjvIlUD6ox1k=";
    npmDepsHash = "sha256-iyp3oJHI8I4XUsidr/tFqJPqG6k4BChh+5D8XRTkwtE=";
    description = "Chrome DevTools MCP server and CLI";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    extraPostPatch = ''
      substituteInPlace build/src/config/ConfigParser.js \
        --replace-fail "resolvedArgs[key] = option.default;" "resolvedArgs[key] = key === 'channel' && !resolvedArgs.autoConnect ? 'beta' : option.default;"
    '';
  };
}
