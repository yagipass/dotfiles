{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gh-infra";
  version = "0.17.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "babarot";
    repo = "gh-infra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n2hlCsH94x+tnOu0VKluMCILE732KhODAgP0RRnE/m4=";
  };

  vendorHash = "sha256-w0Ix1xpJQ5H4NttZCjF1ZWE0/o2US5K76X2bxMrtBF4=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=v${finalAttrs.version}"
    "-X=main.revision=${finalAttrs.src.rev}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Declarative GitHub infrastructure management via YAML";
    homepage = "https://github.com/babarot/gh-infra";
    changelog = "https://github.com/babarot/gh-infra/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "gh-infra";
  };
})
