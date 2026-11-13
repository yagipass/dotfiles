{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cccc";
  version = "1.9.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moznion";
    repo = "cccc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UgtL0TxnQrh7P8yVdUYZ0f6MiahXxanVxvYThSEG8AU=";
  };

  cargoHash = "sha256-6eK9Lb5RTqkuSFCqR65qE2joPc00s8W2h300A8gP2VQ=";

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
