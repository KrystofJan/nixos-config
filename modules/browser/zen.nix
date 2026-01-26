{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.browser.zen;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };
}
