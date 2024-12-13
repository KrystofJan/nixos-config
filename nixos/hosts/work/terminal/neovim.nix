
{ config, lib, pkgs, ... }:

{
    options  = {
        nixosNvimConfig.enable = lib.mkEnableOption "enables nixos neovim";
    };

    config = lib.mkIf config.nixosNvimConfig.enable {
          programs.neovim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;

            extraPackages = with pkgs; [
                # lsps
                lua-language-server
                nil
                rust-analyzer
                gopls
                nodePackages_latest.typescript-language-server
                csharp-ls

                #formatters
                stylua
                rustfmt
                prettierd
            ];

            plugins = with pkgs.vimPlugins; [
                comment-nvim
                friendly-snippets
                nvim-lspconfig
                gruvbox-nvim
                base16-nvim
                gitsigns-nvim
                lazygit-nvim
                which-key-nvim
                telescope-nvim
                telescope-fzf-native-nvim 
                plenary-nvim
                telescope-ui-select-nvim
                nvim-web-devicons
                fidget-nvim
                neodev-nvim
                conform-nvim
                nvim-cmp
                luasnip
                cmp_luasnip
                cmp-nvim-lsp
                cmp-path
                todo-comments-nvim
                mini-nvim
                nvim-treesitter.withAllGrammars
                lualine-nvim
                oil-nvim
            ];
          };
    };
}
