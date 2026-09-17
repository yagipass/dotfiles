_:

let
  registries = {
    npmjs = "https://registry.npmjs.org/";
    flatt = "https://npm.flatt.tech";
  };
  registry = registries.flatt;
  minReleaseDays = 7;
in
{
  programs.npm = {
    enable = true;

    settings = {
      inherit registry;
      ignore-scripts = true;
      min-release-age = minReleaseDays;
    };
  };

  programs.bun = {
    enable = true;

    settings.install = {
      inherit registry;
      minimumReleaseAge = minReleaseDays * 24 * 60 * 60;
    };
  };
}
