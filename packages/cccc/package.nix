{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cccc";
  version = "1.10.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moznion";
    repo = "cccc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sZ2ciJ8d4034VmT6Uh68vW8mNSNwavMneGjNzk5lNtY=";
  };

  cargoHash = "sha256-xAsS/Bvvm1qlPoteONgEI0yzgUP3W4UN/SzSlJKGjzw=";

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
