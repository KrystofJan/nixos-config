{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.waygang.base;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (pkgs.waybar.overrideAttrs (old: {
        mesonFlags = old.mesonFlags ++ ["-Dexperimental=true"];
      }))
      dunst
      libnotify
      swww
      starship
      ghostty
      pavucontrol
      wev
      wl-clipboard
      imagemagick
      brightnessctl
      imv
      nemo
      nemo-with-extensions
      udisks
      udiskie
      grim
      slurp

      networkmanagerapplet
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.martian-mono
      jetbrains-mono
    ];

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      xkb.layout = "us";
      xkb.variant = "";
    };

    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
