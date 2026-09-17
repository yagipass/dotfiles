{
  lib,
  stdenvNoCC,
  fetchurl,
  zulu21,
}:

let
  version = "9.1.2";
  build = "05";
  major = lib.versions.major version;
in
stdenvNoCC.mkDerivation {
  pname = "jdk-mission-control";
  inherit version;

  src = fetchurl {
    url = "https://download.java.net/java/GA/jmc${major}/${build}/binaries/jmc-${version}_macos-aarch64.tar.gz";
    hash = "sha256-wxw4Th1B4Dokgm8LPGcZ+CU47joARd7mM+KSKzgHRnY=";
  };

  sourceRoot = "jmc-${version}_macos-aarch64";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    app="JDK Mission Control.app"
    mkdir -p "$out/Applications"
    cp -R "$app" "$out/Applications/"

    # Insert -vm before -vmargs in jmc.ini so JMC runs on the Nix JDK.
    ini="$out/Applications/$app/Contents/Eclipse/jmc.ini"
    awk -v vm="${zulu21}/bin/java" '
      $0 == "-vmargs" && !done { print "-vm"; print vm; done = 1 }
      { print }
    ' "$ini" > "$ini.tmp"
    mv "$ini.tmp" "$ini"

    runHook postInstall
  '';

  meta = {
    description = "Tools to manage, monitor, profile and troubleshoot Java applications";
    homepage = "https://jdk.java.net/jmc/${major}/";
    license = lib.licenses.upl;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "aarch64-darwin" ];
  };
}
