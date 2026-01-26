{
  lib,
  config,
  ...
}: let
  mkGreetdSession = user: command: {
    enable = true;
    settings.default_session = {
      inherit user command;
    };
  };
in {
  imports = [
    ./base.nix
    ./hyprland.nix
    ./mangowc.nix
  ];

  config._module.args = {
    inherit mkGreetdSession;
  };

  options.waygang = {
    base.enable = lib.mkEnableOption "Enable base Wayland setup";

    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland";
      user = lib.mkOption {
        type = lib.types.str;
        description = "User for Hyprland greetd session";
      };
    };

    mangowc = {
      enable = lib.mkEnableOption "Enable MangoWC";
      user = lib.mkOption {
        type = lib.types.str;
        description = "User for MangoWC greetd session";
      };
    };
  };
}
