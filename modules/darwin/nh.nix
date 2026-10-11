{
  config,
  lib,
  pkgs,
  ...
}:

{
  launchd.daemons.nh-clean = {
    command = "${lib.getExe pkgs.nh} clean all --keep-one";
    path = [ config.nix.package ];
    serviceConfig.StartCalendarInterval = [
      {
        Weekday = 1;
        Hour = 0;
        Minute = 0;
      }
    ];
  };
}
