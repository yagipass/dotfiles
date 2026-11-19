{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cccc";
  version = "1.9.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moznion";
    repo = "cccc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8srk48lV42kjXulx1v+LvuYPeuKQaqIj+0gH7j7gsUQ=";
  };

  cargoHash = "sha256-r8LPkv6p3Y8+gK50wrU6EZ3cpjM1V/jhRXyfOMEBaT4=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  cargoBuildFlags = [
    "--package"
    "cccc-cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeCheckInputs = [ gitMinimal ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Cognitive and cyclomatic complexity measurement tool";
    homepage = "https://github.com/moznion/cccc";
    changelog = "https://github.com/moznion/cccc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "cccc";
  };
})
