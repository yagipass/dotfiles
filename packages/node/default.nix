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

      npmRebuildFlags = [ "--ignore-scripts" ];
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
    version = "1.12.0";
    hash = "sha256-Ignut/iWDRCSZ97YoJMVJC6fINVXDgMi3uSDdHlYAsY=";
    npmDepsHash = "sha256-QZqMc/GEh0pj7Gajv/4JwzWF5alxFl9IUXrzPGtBzTw=";
    description = "Chrome DevTools MCP server and CLI";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    extraPostPatch = ''
      substituteInPlace build/src/config/ServerConfig.js \
        --replace-fail "...parseDefaultArgs(baseOptions)," "...parseDefaultArgs(baseOptions), ...(explicitArgs.autoConnect ? {} : { channel: 'beta' }),"
    '';
  };
}
