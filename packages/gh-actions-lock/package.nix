{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gh-actions-lock";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-actions-lock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hbduX3k4PHJzGj9o84EcDV2+tYedXVB1FW1clHQslAs=";
  };

  postPatch = ''
    substituteInPlace cmd/gh-actions-lock/run.go \
      --replace-fail 'return info.Main.Version' 'return "v${finalAttrs.version}"'
  '';

  vendorHash = "sha256-MS0GDAo/COikI5LwfgNPR83MhY6fAFg+Lpmzkv86X3M=";

  ldflags = [
    "-s"
  ];

  env.CGO_ENABLED = "0";

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "GitHub CLI extension to lock workflow dependencies";
    homepage = "https://github.com/github/gh-actions-lock";
    changelog = "https://github.com/github/gh-actions-lock/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gh-actions-lock";
    platforms = lib.platforms.unix;
  };
})
