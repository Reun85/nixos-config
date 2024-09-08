{ config, lib, pkgs, inputs, ... }:

let cfg = config._custom.programs.neovim;
in {
  imports = [ ./options.nix ];

  config = lib.mkIf cfg.enable {
    _custom.programs.neovim = {
      setBuildEnv = true;
      withBuildTools = true;
      #package = pkgs.prevstable-neovim.neovim-unwrapped;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    };

      home.packages = with pkgs; [
        neovide # gui

        marksman # required by nvim-lspconfig
        #_custom.neovim-remote # required by lazygit
        tree-sitter # required by nvim-treesitter

        # required by nvim
        fswatch
        wl-clipboard # required in wayland to copy

        # required by telescope.nvim
        fd
        ripgrep
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "neovide";
      };


      programs.git.extraConfig.core.editor = "nvim";


    };
}
