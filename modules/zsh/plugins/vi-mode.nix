{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.plugins.vi-mode.enable = lib.mkEnableOption "vi-mode";

      config = lib.mkIf config.plugins.vi-mode.enable {
        zsh.plugins.vi-mode = {
          package = pkgs.zsh-vi-mode;
          source = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          defer = "eager";
        };
      };
    })
  ];
}
