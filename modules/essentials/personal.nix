{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.essentials.personal;
in {
  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "spotify"
        ];
    };

    environment.systemPackages = with pkgs; [
      discord
      spotify
    ];
  };
}
