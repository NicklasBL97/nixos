{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];

    extraLuaConfig = ''

      ${builtins.readFile ./../../modules/home-manager/editors/nvim/options.lua}


    '';
  };
}
