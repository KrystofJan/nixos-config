{
  lib,
  config,
  ...
}: {
  options = {
    bootGrub = {
      enable = lib.mkEnableOption "Enable grub boot loader";
    };
  };
  config = lib.mkIf config.bootGrub.enable {
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 5;
    };
  };
}
