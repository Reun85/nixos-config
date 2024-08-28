{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:{
imports = [
    inputs.ags.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    bun
    dart-sass
    fd
    brightnessctl
    swww
matugen
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  programs.ags = {
    enable = true;
  };
xdg.configFile."ags".source = ./dotfiles/ags;
}
