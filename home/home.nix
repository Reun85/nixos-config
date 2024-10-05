# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }:
let userName = "reun";
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    outputs.homeManagerModules

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./hypr.nix
    ./ags.nix
    ./theme.nix
  ];

  config = {

    nixpkgs = {
      # You can add overlays here
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages

        # You can also add overlays exported from other flakes:
        #neovim-nightly-overlay.overlays.default

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
      ];
      # Configure your nixpkgs instance
      config = {
        # Disable if you don't want unfree packages
        allowUnfree = true;
      };
    };

    _custom.programs.neovim = {
      enable = true;
      configFolder = config.lib.file.mkOutOfStoreSymlink
        "${config._custom.globals.configDirectory}/home/dotfiles/nvim";
    };

    _custom.globals = {
      userName = userName;
      homeDirectory = "/home/${userName}";
      configDirectory = "/home/${userName}/all/nix-config";
    };
    home = {
      username = userName;
      homeDirectory = "/home/${userName}";
    };

    home.packages = with pkgs; [
      steam
      tidal-hifi
      delta
      neofetch
      unzip
      vesktop
      discord
    ];

    programs.home-manager.enable = true;

    programs.git = {
      enable = true;
      userName = "Reun";
      userEmail = "gugigergo@gmail.com";
    };

    programs.git-credential-oauth.enable = true;

    xdg.configFile."neofetch".source = ./dotfiles/neofetch;

    programs.zathura.enable = true;
    xdg.configFile."zathura".source = ./dotfiles/zathura;

    programs.btop.enable = true;
    xdg.configFile."btop".source = ./dotfiles/btop;

    programs.starship.enable = true;
    xdg.configFile."starship.toml".source = ./dotfiles/starship.toml;

    programs.wezterm.enable = true;
    xdg.configFile."wezterm".source = ./dotfiles/wezterm;

    # Lazygit is installed for root even
    xdg.configFile."lazygit".source = ./dotfiles/lazygit;

    programs.fish.enable = true;
    programs.fish.shellInit = ''
      function yazi_cwd
        set tmp (mktemp -t "yazi_cwd.XXXXXX")
        command	yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      end
      alias yazi yazi_cwd
    '';

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    programs.yazi = {
      enable = true;
      #plugins = {
      #lazygit = 
      #"https://github.com/Lil-Dank/lazygit.yazi";

      #};
    };

    xdg.configFile."yazi".source = ./dotfiles/yazi;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
  };
}
