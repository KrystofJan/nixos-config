{ config, pkgs, ... }:

{
  # imports = [
  #     ../../main-user.nix
  # ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zahry";
  home.homeDirectory = "/home/zahry";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/zahry/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # wayland.windowManager.sway = {
  #
  #   config = rec {
  #       modifier = "Mod4";
  #       terminal = "kitty";
  #       startup = [
  #           {command = "kitty";}
  #           {command = "firefox";}
  #       ];
  #   };
  # };


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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
