{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.plugins.omz.git = {
        enable = lib.mkEnableOption "OMZ git plugin";
        after = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Plugins that must load before OMZ git.";
        };
        defer = lib.mkOption {
          type = lib.types.enum [
            "eager"
            "prompt"
            "idle"
            "lazy"
          ];
          default = "idle";
          description = "Load strategy for OMZ git.";
        };
      };

      config = lib.mkIf config.plugins.omz.git.enable {
        zsh.plugins.omz-git = {
          package = pkgs.oh-my-zsh;
          sources = [
            "share/oh-my-zsh/lib/git.zsh"
            "share/oh-my-zsh/plugins/git/git.plugin.zsh"
          ];
          inherit (config.plugins.omz.git) after defer;
        };
      };
    })
  ];
}
