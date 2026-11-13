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
  version = "2.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "jactionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ikUVmurWrKP18XMth0lhnsvF0JT4gVoiNGTN+5AAL3U=";
  };

  vendorHash = "sha256-jf7hKPnaSl4iTYT0mtRRAEmgLKAA/lj0vSVoO9+iOvw=";

  ldflags = [
    "-s"
    "-X"
    "github.com/jdx/jactionlint/v${lib.versions.major finalAttrs.version}.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

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
        "TestFetchError/not_found"
        "TestFetchRemoteYAML"
        "TestWriteOutdatedActionAsJSONL"
        "TestDetectNewRelease"
        "TestDetectNoRelease/no_new_version.json"
        "TestCouldNotFetch"
        "TestFetchURL"
        "TestOwnWorkflowsPlanAndDryRun/comment-release-fixes.yml"
        "TestOwnWorkflowsPlanAndDryRun/release.yaml"
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
