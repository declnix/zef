{ lib, ... }:
{
  zsh.modules = [
    ({ config, lib, pkgs, ... }:
      let
        plugins = config.zsh.plugins;

        toSource = n: p:
          let sources = lib.optional (p.source != null) p.source ++ p.sources;
          in lib.concatStringsSep "\n" (
            (map (s: "source ${p.package}/${s}") sources) ++
            (lib.optional (p.init != "") p.init)
          );
      in
      {
        options.zsh.rc = lib.mkOption { type = lib.types.lines; internal = true; };
        config.zsh.rc = lib.mkOrder 50 ''
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList toSource (lib.filterAttrs (_: p: p.defer == "eager") plugins))}
          ${let p = lib.filterAttrs (_: p: p.defer == "idle") plugins;
            in lib.optionalString (p != {}) ''
              autoload -Uz add-zsh-hook
              _zef_idle_check() {
                if (( KEYS_QUEUED_COUNT || PENDING )); then
                  sched +1 _zef_idle_check
                else
                  ${lib.concatStringsSep "\n" (lib.mapAttrsToList toSource p)}
                fi
              }
              _zef_idle_init() {
                add-zsh-hook -d precmd _zef_idle_init
                _zef_idle_check
              }
              add-zsh-hook precmd _zef_idle_init
            ''
          }
        '';
      })
  ];
}
