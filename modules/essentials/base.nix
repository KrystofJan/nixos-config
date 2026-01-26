{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.essentials.base;
in {
  config = lib.mkIf cfg.enable {
    programs = {
      git.enable = true;
      zsh.enable = true;
    };

    environment.systemPackages = with pkgs; [
      ffmpeg
      vim
      git
      gcc
      gnumake
      killall
      wget
    ];
  };
}
