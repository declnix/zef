{ lib, ... }:
{
  options.zsh.modules = lib.mkOption {
    type = lib.types.listOf lib.types.deferredModule;
    default = [ ];
    description = "NixOS modules collected by import-tree and passed to zshConfiguration.";
  };
}
