{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zabrze";
  version = "0.7.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Ryooooooga";
    repo = "zabrze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OmwU7/SQqEAzZo7/Eix3yc+VLEU6+/NIiALvpU3PlKA=";
  };

  cargoHash = "sha256-9UZSOXTWvX9jPE0crGb/hUpemuVhEGgyzs+HL3QwIgg=";

  cargoTestFlags = [ "--bins" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Zsh abbreviation expansion plugin";
    homepage = "https://github.com/Ryooooooga/zabrze";
    changelog = "https://github.com/Ryooooooga/zabrze/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "zabrze";
  };
})
