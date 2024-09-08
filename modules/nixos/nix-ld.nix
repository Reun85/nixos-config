{ config, pkgs, lib, inputs, ... }:

let cfg = config._custom.programs.nix-ld;
in {
  imports = [inputs.nix-ld.nixosModules.nix-ld];
  options._custom.programs.nix-ld.enable = lib.mkEnableOption { };

  config = lib.mkIf cfg.enable {
    programs.nix-ld.dev.enable = false;
    #programs.nix-ld.enable = true;
  };
}
