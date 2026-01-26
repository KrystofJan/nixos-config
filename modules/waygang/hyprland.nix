{
  lib,
  config,
  mkGreetdSession,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.waygang.hyprland;
in {
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
      hyprlock
      hyprcursor
      hypridle
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];

    services.greetd = mkGreetdSession cfg.user "Hyprland";
  };
}
