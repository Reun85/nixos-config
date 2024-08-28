# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
#./hypr.nix
./ags.nix
./theme.nix
  ];

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

  home = rec {
    username = "reun";
    homeDirectory = "/home/${username}";
  };


  # Add stuff for your user as you see fit:
  home.packages = with pkgs;[ steam tidal-hifi delta neofetch kitty
(pkgs.discord.override {withVencord=true;}) ];


  # Enable home-manager and git
  programs.home-manager.enable = true;

programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

programs.git = {enable = true;
userName = "Reun";
userEmail = "gugigergo@gmail.com";



};

programs.git-credential-oauth.enable=true;


xdg.configFile."neofetch".source = ./dotfiles/neofetch;

programs.zathura.enable=true;
xdg.configFile."zathura".source = ./dotfiles/zathura;


 programs.btop.enable=true;
xdg.configFile."btop".source = ./dotfiles/btop;

programs.starship.enable=true;
xdg.configFile."starship.toml".source = ./dotfiles/starship.toml;

programs.wezterm.enable=true;
xdg.configFile."wezterm".source = ./dotfiles/wezterm;

# Lazygit is installed for root even
xdg.configFile."lazygit".source = ./dotfiles/lazygit;

xdg.configFile."ags".source = ./dotfiles/ags;
xdg.configFile."hypr".source = ./dotfiles/hypr;


programs.fish.enable=true;
programs.fish.shellInit = 
''
# You may also like to assign a key (Ctrl-O) to this command:
#     bind \co lfcd
function lfcd
    cd (command lf -print-last-dir "$argv")
end
alias lf lfcd
'';



xdg.configFile."lf".source = ./dotfiles/lf;

home.sessionVariables = { 
        EDITOR = "nvim"; 
        VISUAL = "nvim";
        };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
