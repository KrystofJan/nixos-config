{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.obs;
in {
  options.obs = {
    enable = lib.mkEnableOption "Enable OBS Studio with wrapped plugins";

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
      example = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
      ];
      description = "OBS Studio plugins to include in the wrapped OBS package.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.wrapOBS {
        plugins = cfg.plugins;
      })
    ];
  };
}
