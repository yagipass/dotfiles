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
      '';

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
    version = "1.9.0";
    hash = "sha256-+J2SyREEfYtSCpRx8vtX4+U8w60sKZc2YO4weA0xNxE=";
    npmDepsHash = "sha256-qJwMJDtq6IwRzKuFws5MKnfI0WouEGIFXMELIZDPlKs=";
    description = "Chrome DevTools MCP server and CLI";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
  };
}
