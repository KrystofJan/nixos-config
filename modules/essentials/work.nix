{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.essentials.work;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
      vscode
      postman
      obsidian
    ];
  };
}
