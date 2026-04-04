{ config, pkgs, ... }:

{
  home.username = "dmehala";
  home.homeDirectory = "/home/dmehala";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = [
    pkgs.neovim#0.11.5
    pkgs.zig#0.15.2
    pkgs.swaybg
    pkgs.waypaper
    pkgs.bazelisk
  ];

  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/hypr";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/nvim";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/waybar";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/ghostty";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services.gpg-agent.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Programs
  # TODO:
  #  - hyprland
  #  - waybar
  programs.gpg.enable = true;

  programs.fzf.enable = true;

  programs.elephant = {
    enable = true;
    installService = true;
  };

  programs.walker = {
    enable = true;
    runAsService = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      g = "git";
    };
    shellInit = ''
      if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
      end
    '';
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        addKeysToAgent = "yes";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Damien Mehala";
      user.email = "gh@sunnymail.cc";
      alias = { 
        co = "checkout"; 
        st = "status";
      };
    };
  };
}
