{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.plugins.autosuggestions.enable = lib.mkEnableOption "zsh-autosuggestions";

      config = lib.mkIf config.plugins.autosuggestions.enable {
        zsh.plugins.autosuggestions = {
          package = pkgs.zsh-autosuggestions;
          source = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          defer = "eager";
        };
      };
    })
  ];
}
