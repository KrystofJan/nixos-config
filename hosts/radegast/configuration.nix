# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/bootloader/grub.nix
    ./hardware-configuration.nix
  ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    hostName = "radegast"; # Define your hostname.
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [22 53 80 443];
    firewall.allowedUDPPorts = [53 67];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bielobog = {
    isNormalUser = true;
    description = "bielobog";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUf/tpXgOr7UCC4F/dV+yS8vhmF07LQns+EW7meVpTp jendazah@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCOwTJ1hVXo3EONePvgsNxkUK45KWBjaNcmofDKkAiP jan.zahradnik@profiq.com"
    ];
  };

  # Enable automatic login for the user.
  services.logind.lidSwitchExternalPower = "ignore";
  services.getty.autologinUser = "bielobog";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    gcc
    gnumake
    killall
    wget
    openssl
    mkcert
    dig
  ];

  programs.git = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.openssh = {
    enable = true;
    ports = [22];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;

      PermitRootLogin = "prohibit-password";
      X11Forwarding = false;
      UseDns = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = ["bielobog"];
}
