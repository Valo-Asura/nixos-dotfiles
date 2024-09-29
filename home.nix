{ config, pkgs, ... }:

{
  home.username = "asura";
  home.homeDirectory = "/home/asura";

  home.stateVersion = "24.05"; # Please read the comment before changing.
  imports = [ ./rofi/default.nix ];

  programs.git = {
    enable = true;
    userName = "vimalranghar";
    userEmail = "vimalranghar016@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "~/.dotfiles";
    };
  };


  home.packages = [
     pkgs.hello

  ];

  home.file = {
  
  };


  home.sessionVariables = {
    SSH_ASKPASS = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
