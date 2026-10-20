{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "redmine-cli";
  version = "2.14.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aarondpn";
    repo = "redmine-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jaBGoY+ZltvM1jHj8zIJfTBto/Urlf43b7afnTvxmkA=";
  };

  vendorHash = "sha256-LPUeVGcGQgIAMS9CtvkNwqLkhpXRMdRy2yq3bjwKJSM=";

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
