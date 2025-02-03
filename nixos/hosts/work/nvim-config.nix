{coworknfig, pkgs, ...}:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      nil
    ];

    plugins = with pkgs.vimPlugins; [
        comment-nvim
        nvim-lspconfig
        gruvbox-nvim
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
	];
  };
}
