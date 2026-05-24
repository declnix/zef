{ lib, ... }:

let
  pluginSubmodule = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "Package containing plugin scripts.";
      };
      source = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Single plugin script path inside the package.";
      };
      sources = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Ordered list of plugin script paths inside the package.";
      };
      init = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional zsh commands run after sourcing plugin files.";
      };
      after = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Plugin names that must load before this plugin.";
      };
      defer = lib.mkOption {
        type = lib.types.enum [
          "eager"
          "prompt"
          "idle"
          "lazy"
        ];
        default = "lazy";
        description = "Load strategy: eager (inline), prompt (first prompt), idle (sched), lazy (unscheduled stub).";
      };
    };
  };

  module =
    { config, lib, ... }:
    {
      options.zsh.plugins = lib.mkOption {
        type = lib.types.attrsOf pluginSubmodule;
        default = { };
        description = "Plugin registry. Individual plugin modules write here; render.nix reads from here.";
      };

      options.zsh.extraPlugins = lib.mkOption {
        type = lib.types.attrsOf pluginSubmodule;
        default = { };
        description = "User-defined raw plugin specs merged into the plugin registry.";
      };

      config.zsh.plugins = config.zsh.extraPlugins;
    };

in
{
  zsh.modules = [ module ];
}
