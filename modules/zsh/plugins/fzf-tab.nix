{ inputs, ... }:

let
  module = { config, lib, ... }: {
    options.plugins.fzf-tab.enable = lib.mkEnableOption "fzf-tab";

    config = lib.mkIf config.plugins.fzf-tab.enable {
      zsh.plugins.fzf-tab = {
        package = {
          outPath = inputs.fzf-tab;
          name = "fzf-tab";
        };
        source = "fzf-tab.plugin.zsh";
        init = "enable-fzf-tab";
        defer = "idle";
      };
    };
  };
in
{
  zsh.modules = [ module ];

  flake-file.inputs.fzf-tab = {
    url = "github:Aloxaf/fzf-tab";
    flake = false;
  };
}
