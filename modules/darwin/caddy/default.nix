{
  config,
  lib,
  pkgs,
  ...
}:

let
  caddy = pkgs.callPackage ../../../packages/caddy/package.nix { };
  label = config.launchd.daemons.caddy.serviceConfig.Label;
in
{
  launchd.daemons.caddy = {
    script = ''
      set -eu
      if ! CF_API_TOKEN=$(/usr/bin/security find-generic-password -s caddy-cloudflare -w /Library/Keychains/System.keychain); then
        echo "caddy-cloudflare is missing from the System keychain; not starting Caddy" >&2
        exit 0
      fi
      export CF_API_TOKEN
      exec ${lib.getExe caddy} run --adapter caddyfile --config ${./Caddyfile}
    '';
    environment.HOME = "/var/root";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
    };
  };

  system.activationScripts.postActivation.text = ''
    /bin/launchctl kickstart system/${label} || echo "warning: failed to kickstart ${label}" >&2
  '';
}
