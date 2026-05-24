{ config, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      zshrc = config.flake.lib.zshConfiguration {
        inherit pkgs;
        modules = [
          {
            zsh.extraPlugins.test-plugin = {
              package = pkgs.writeTextDir "noop.zsh" "";
              init = "echo 1 > $NIX_ZSH_MARKER_FILE && exit 0";
              defer = "idle";
            };
          }
        ];
      };
      zdotdir = pkgs.runCommand "zdotdir" { } "mkdir -p $out && cp ${zshrc} $out/.zshrc";
      zsh = pkgs.symlinkJoin {
        name = "zef-defer";
        paths = [ pkgs.zsh ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/zsh --set ZDOTDIR ${zdotdir}";
        meta.mainProgram = "zsh";
      };
    in
    {
      checks.defer = pkgs.runCommand "zef-defer" { nativeBuildInputs = [ pkgs.util-linux ]; } ''
        export HOME="$(mktemp -d)"
        export NIX_ZSH_MARKER_FILE="$(mktemp)"
        trap 'rm -f "$NIX_ZSH_MARKER_FILE"' EXIT
        timeout 5 script -qfec "${lib.getExe zsh} -i" /dev/null > /dev/null 2>&1
        if [ -s "$NIX_ZSH_MARKER_FILE" ]; then
          echo "SUCCESS" > $out
        else
          echo "FAIL: Plugin did not initialize"
          exit 1
        fi
      '';
    };
}
