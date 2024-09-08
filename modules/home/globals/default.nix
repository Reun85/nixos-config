{ config, lib, ... }:
{
  # https://discourse.nixos.org/t/using-mkif-with-nested-if/5221/4
  # https://discourse.nixos.org/t/best-resources-for-learning-about-the-nixos-module-system/1177/4
  # https://nixos.org/manual/nixos/stable/index.html#sec-option-types
  options._custom.globals = {
    userName = lib.mkOption {
      type = lib.types.str;
      example = "bob";
      description = "Default user name";
    };
    homeDirectory = lib.mkOption {
      type = lib.types.str;
      example = "/home/bob";
      description = "Path of user home folder";
    };
    configDirectory = lib.mkOption {
      type = lib.types.str;
      example = "/home/bob/nix-config";
      description = "Path of config folder";
    };
  };

}
