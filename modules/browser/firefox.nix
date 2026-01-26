{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.browser.firefox;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.firefox
    ];
  };
}
