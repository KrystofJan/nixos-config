{ config, pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
        # Dev
        vim 
        neovim
        git
        gcc
        wget
        curl

        vscode
        postman
    ];

    
    programs.git = {
        enable = true;
        userName = "Jan-Krystof Zahradnik";
    };
}
