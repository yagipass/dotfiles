{
  config,
  lib,
  pkgs,
  homeDirectory,
  ...
}:

let
  devcerts = "${homeDirectory}/.local/share/certs";
  caddyfile = pkgs.replaceVars ./Caddyfile { inherit devcerts; };
in
{
  launchd.daemons = {
    caddy = {
      command = "${lib.getExe pkgs.caddy} run --adapter caddyfile --config ${caddyfile}";
      environment.HOME = "/var/root";
      serviceConfig.KeepAlive.PathState."${devcerts}/privkey.pem" = true;
    };

    caddy-restart = {
      command = "/bin/launchctl kickstart -k system/${config.launchd.daemons.caddy.serviceConfig.Label}";
      serviceConfig.WatchPaths = [ devcerts ];
    };
  };
}
