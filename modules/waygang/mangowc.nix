{
  lib,
  config,
  mkGreetdSession,
  pkgs,
  ...
}: let
  cfg = config.waygang.mangowc;
in {
  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;

    environment.systemPackages = with pkgs; [
      foot
      wmenu
      swaybg
      hyprlock
      wlr-randr
    ];

    services.greetd = mkGreetdSession cfg.user "mango";
  };
}
