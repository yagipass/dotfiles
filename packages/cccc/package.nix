{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cccc";
  version = "1.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moznion";
    repo = "cccc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E3KQkLj1yG5AHxXV273NALR7w2LcNnrIpcm4gHFuHKU=";
  };

  cargoHash = "sha256-V9o/EYWqiW8Ipwxt0N6oT79BmByWHdDYeYQxL1dssdg=";

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
