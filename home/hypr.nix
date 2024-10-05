{ inputs, outputs, lib, config, pkgs, ... }: {

  # Hyprland has to be downloaded as a system package

  xdg.configFile."hypr".source = ./dotfiles/hypr;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  #
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
