{lib, config, pkgs, ... }: 
let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";
    
    userName = lib.mkOption {
      default = "zahry";
      description = ''
	username
      '';
    }; 
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "Jan-Krystof Zahradnik";
      extraGroups = ["networkmanager" "wheel" "video" "i2c"];
      shell = pkgs.zsh;
      packages = with pkgs; [];
    };
  };
}
