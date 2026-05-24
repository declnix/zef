{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }: {
      options.plugins.syntax-highlighting.enable = lib.mkEnableOption "zsh-syntax-highlighting";

      config = lib.mkIf config.plugins.syntax-highlighting.enable {
        zsh.plugins.syntax-highlighting = {
          package = pkgs.zsh-syntax-highlighting;
          source = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
          defer = "eager";
          after = [ "autosuggestions" ];
        };
      };
    })
  ];
}
