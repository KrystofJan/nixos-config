{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    devices = ["nodev"];
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 5;
  };
}
# {
#   boot.loader.systemd-boot.enable = true;
#   boot.loader.systemd-boot.configurationLimit = 5; # Keep only 5 generations
# }

