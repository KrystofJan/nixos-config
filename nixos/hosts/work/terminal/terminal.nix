{pkgs, lib, ...}:

{
    imports = [
        ./neovim.nix
        ./terminal-programs.nix
    ];

  nixosNvimConfig.enable = true;
}

