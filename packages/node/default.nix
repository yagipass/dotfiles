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
    version = "1.14.0";
    hash = "sha256-jU9sKhQe+IUj/2HhXMMuwWSJFZ4IeesfP57Ke44bG4c=";
    npmDepsHash = "sha256-WvoifGeIhAhC9YE85hjjk9cDvF7O3eQl6ml+nFftHro=";
    description = "Chrome DevTools MCP server and CLI";
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
  };
}
