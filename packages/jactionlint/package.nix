{
  lib,
  buildGoModule,
  fetchFromGitHub,
  bashInteractive,
  gitMinimal,
  shellcheck,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "jactionlint";
  version = "2.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "jactionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oCfz/PVcEPsol8OsvVDTWsgDx+/0V9dqdlUZkn4Irmc=";
  };

  vendorHash = "sha256-SnP9Siop3zgGrVMuHU2IOqDkPKnfyJZVxUB/iBV8hIA=";

  ldflags = [
    "-s"
    "-X"
    "github.com/jdx/jactionlint/v${lib.versions.major finalAttrs.version}.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    bashInteractive
    gitMinimal
    shellcheck
  ];

  preCheck = ''
    git init -q
  '';

  postCheck = ''
    rm -rf .git
  '';

  checkFlags =
    let
      skippedTests = [
        "TestMainGenerateOK"
        "TestMainCheckOK"
        "TestMainCheckQuietOK"
        "TestUpdateOK"
        "TestLinterFormatErrorMessageInSARIF"
        "TestNoFixGoldens"
        "TestOnlineCoverageGoldens"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Static checker for GitHub Actions workflow files";
    homepage = "https://github.com/jdx/jactionlint";
    changelog = "https://github.com/jdx/jactionlint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "jactionlint";
  };
})
