# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let 
monitorConfig =  
''Section "Monitor"
Identifier "DP-1"
Option "Primary" "true"
EndSection
Section "Screen"
Identifier "Screen0"
Monitor "DP-1"
EndSection
Section "Device"
Identifier "Device0"
Driver "modesetting"
EndSection'';

in
{
  # You can import other NixOS modules here
  imports = [

    outputs.nixosModules
      inputs.sddm-sugar-candy-nix.nixosModules.default
inputs.lanzaboote.nixosModules.lanzaboote

    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  config ={
    #_custom.programs.nix-ld.enable=true;
  nixpkgs = {
    # You can add overlays here
    overlays = [
            inputs.sddm-sugar-candy-nix.overlays.default
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };



  networking.hostName = "Nixos-PC";


	services.xserver = {
enable = true;

displayManager.sessionCommands = ''
      xrandr --output DP-1 --primary
    '';
    

};


services.displayManager.sddm = {
	enable=true;
	sugarCandyNix = {
		enable=true;
		settings=
		{
			ForceHideCompletePassword = true;
FormPosition="left";
HaveFormBackground=true;
PartialBlur=true;


		};
	};
};

	# Enable the KDE Plasma Desktop Environment.
	#services.displayManager.sddm.enable = true;
	#services.desktopManager.plasma6.enable = true;




programs.hyprland ={
	enable=true;
	xwayland.enable=true;
	};
	xdg.portal.enable =true;
	xdg.portal.extraPortals= [pkgs.xdg-desktop-portal-gtk];


# fonts
fonts.packages = with pkgs; [
(nerdfonts.override{fonts = ["FiraCode" "JetBrainsMono"];})
];



programs.fish.enable=true;
  users.users = {
   reun = {
shell = pkgs.fish;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
    extraGroups = [ "docker" "networkmanager" "wheel" "audio" ];
    };
  };

  # This setups a SSH server.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };



  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";
time.hardwareClockInLocalTime =true;
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };


  # Configure keymap in X11
  #services.xserver = {
#xkb = {
    #layout = "us";
    #variant = "";
#};
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;


  # bluetooth
hardware.bluetooth = {
enable=true;
settings={
	General = {
		Experimental = true;
	};
};
};

hardware.bluetooth.powerOnBoot=true;
services.blueman.enable=true;

# Using Bluetooth headset buttons to control media player
systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
};

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
   services.libinput.enable = true;


  # Install firefox.
  programs.firefox.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
 ripgrep fzf
    vim
wget curl btop ncdu
git gnumake lazygit
inputs.home-manager.packages.${pkgs.system}.default
      nix-index
  ];

environment.variables = { 
        EDITOR = "vim"; 
        VISUAL = "vim";
        };




# -------


#nvidia stuff
    
# Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

# Secure boot
  boot.loader.efi.canTouchEfiVariables = true;
# Lanzaboote currently replaces the systemd-boot module.
# This setting is usually set to true in configuration.nix
# generated at installation time. So we force it to false
# for now.
boot.loader.systemd-boot.enable = lib.mkForce false;

boot.lanzaboote = {
enable = true;
pkiBundle = "/etc/secureboot";
};




  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
    };
}
