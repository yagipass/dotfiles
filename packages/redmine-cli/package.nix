{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "redmine-cli";
  version = "2.20.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aarondpn";
    repo = "redmine-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y8mAdQotF1QTRW6S8dyyF05tiSyWRWRFLGk18AIqE10=";
  };

  vendorHash = "sha256-Q998+7ZQmYhNSNYKEXu4Kmw5JfPV1wMfGJrOKZGP/Es=";

  subPackages = [ "cmd/redmine" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/redmine --set REDMINE_NO_UPDATE_CHECK 1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Command-line interface for Redmine with AI agent Skills and MCP integration";
    homepage = "https://github.com/aarondpn/redmine-cli";
    changelog = "https://github.com/aarondpn/redmine-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "redmine";
  };
})
