# source: https://github.com/ayamir/nvimdots/blob/main/nixos/neovim/default.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config._custom.programs.neovim;
  inherit (config._custom.globals) userName;
  home= config.home;

  # Inspired from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/nix-ld.nix
  build-dependent-pkgs = with pkgs;
    [
      acl
      attr
      bzip2
      curl
      libsodium
      libssh
      libxml2
      openssl
      stdenv.cc.cc
      systemd
      util-linux
      xz
      zlib
      zstd
      # Packages not included in `nix-ld`'s NixOSModule
      glib
      libcxx
    ] ++ cfg.extraDependentPackages;

  makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
  makeIncludePath = x: makeSearchPathOutput "dev" "include" x;

  nvim-depends-library = pkgs.buildEnv {
    name = "nvim-depends-library";
    paths = map lib.getLib build-dependent-pkgs;
    extraPrefix = "/lib/nvim-depends";
    pathsToLink = [ "/lib" ];
    ignoreCollisions = true;
  };
  nvim-depends-include = pkgs.buildEnv {
    name = "nvim-depends-include";
    paths = splitString ":" (makeIncludePath build-dependent-pkgs);
    extraPrefix = "/lib/nvim-depends/include";
    ignoreCollisions = true;
  };
  nvim-depends-pkgconfig = pkgs.buildEnv {
    name = "nvim-depends-pkgconfig";
    paths = splitString ":" (makePkgConfigPath build-dependent-pkgs);
    extraPrefix = "/lib/nvim-depends/pkgconfig";
    ignoreCollisions = true;
  };
  buildEnv = [ "CPATH=${home.profileDirectory}/lib/nvim-depends/include"
    "CPLUS_INCLUDE_PATH=${home.profileDirectory}/lib/nvim-depends/include/c++/v1"
    "LD_LIBRARY_PATH=${home.profileDirectory}/lib/nvim-depends/lib"
    "LIBRARY_PATH=${home.profileDirectory}/lib/nvim-depends/lib"
    "NIX_LD_LIBRARY_PATH=${home.profileDirectory}/lib/nvim-depends/lib"
    "PKG_CONFIG_PATH=${home.profileDirectory}/lib/nvim-depends/pkgconfig"
  ];
in {
  options = {
    _custom.programs.neovim = {
      enable = mkEnableOption { };
configFolder = mkOption {
      type = types.path;
      description = "Path to your nvim configuration";
      example = "/path/to/folder";
    };
      package = mkOption {
        type = types.package;
        default = pkgs.prevstable-neovim.neovim-unwrapped;
      };
      setBuildEnv = mkEnableOption ''
        Sets environment variables that resolve build dependencies as required by `mason.nvim` and `nvim-treesitter`
        Environment variables are only visible to `nvim` and have no effect on any parent sessions.
        Required for NixOS.
      '';
      withBuildTools = mkEnableOption ''
        Include basic build tools like `gcc` and `pkg-config`.
        Required for NixOS.
      '';
      extraDependentPackages = mkOption {
        type = with types; listOf package;
        default = [ ];
        example = literalExpression "[ pkgs.openssl ]";
        description = "Extra build depends to add `LIBRARY_PATH` and `CPATH`.";
      };
    };
  };


  config = mkIf cfg.enable {
#  assertions = [{
    #assertion = cfg.configFolder != null && cfg.enable;
    #message = "The option `myModule.configFolder` must be set when `myModule.enable` is true.";
  #}];
      home.packages = with pkgs;
        [ ripgrep ] ++ optionals cfg.setBuildEnv [
          nvim-depends-include
          nvim-depends-library
          nvim-depends-pkgconfig
          patchelf
        ];
      home.extraOutputsToInstall = optional cfg.setBuildEnv "nvim-depends";
    home.shellAliases.nvim =
    optionalString cfg.setBuildEnv (concatStringsSep " " buildEnv)
    + " SQLITE_CLIB_PATH=${pkgs.sqlite.out}/lib/libsqlite3.so " + "command nvim";


xdg.configFile."nvim".source =config.lib.file.mkOutOfStoreSymlink cfg.configFolder;




      programs.neovim = {
        enable = true;
        package = cfg.package;

        withNodeJs = false;
        withPython3 = false;
        withRuby = false;

        extraPackages = with pkgs;
          [
            # Dependent packages used by default plugins
            doq
            sqlite
          ] ++ optionals cfg.withBuildTools [
            cargo
            clang
            cmake
            gcc
            gnumake
            ninja
            pkg-config
            yarn
          nodejs_22
          python3
          ];

        # NOTE: extraLuaPackages doesn't work?
        # https://github.com/NixOS/nixpkgs/issues/306367
        # https://github.com/NixOS/nixpkgs/pull/301573
        extraLuaPackages = ls:
          with ls; [
            luarocks
          ];
      };
  };
}
