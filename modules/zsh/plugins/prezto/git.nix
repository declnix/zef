{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.plugins.prezto.git = {
        enable = lib.mkEnableOption "Prezto git module";
        after = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Plugins that must load before Prezto git.";
        };
        defer = lib.mkOption {
          type = lib.types.enum [
            "eager"
            "prompt"
            "idle"
            "lazy"
          ];
          default = "prompt";
          description = "Load strategy for Prezto git.";
        };
      };

      config = lib.mkIf config.plugins.prezto.git.enable {
        zsh.plugins.prezto-git = {
          package = pkgs.zsh-prezto;
          source = "share/zsh-prezto/modules/git/init.zsh";
          inherit (config.plugins.prezto.git) after defer;
        };
      };
    })
  ];
}
