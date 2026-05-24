{ lib, inputs, config, ... }:

let
  compileZshPlugin =
    { pkgs, plugin }:
    pkgs.runCommand "${plugin.name}-compiled" { } ''
      set -euo pipefail
      cp -r ${plugin} $out
      chmod -R u+w $out
      find "$out" \
        -type f \
        \( -name "*.zsh" -o -name "*.plugin.zsh" -o -name "*.zsh-theme" \) \
        -exec ${pkgs.zsh}/bin/zsh -fc '
          for f in "$@"; do
            zcompile "$f"
          done
        ' zsh {} +
    '';

  zshConfiguration =
    { pkgs
    , modules ? [ ]
    , specialArgs ? { }
    ,
    }:
    let
      evaluated = lib.evalModules {
        modules = config.zsh.modules ++ modules;
        specialArgs = {
          inherit pkgs inputs compileZshPlugin;
          dag = inputs.dag.lib { inherit lib; };
        } // specialArgs;
      };
    in
    pkgs.writeText "zshrc" evaluated.config.zsh.rc;
in
{
  flake.lib.zshConfiguration = zshConfiguration;
}
