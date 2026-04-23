{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  unsupported = builtins.abort "unsupported platform";
in
{
  home.username = "dmehala";
  home.homeDirectory = "/home/dmehala";

  home.stateVersion = "25.11";

  home.packages =  with pkgs; ([
    neovim#0.12.1
    zig#0.15.2
    bazelisk
    luajitPackages.tree-sitter-cli
    nerd-fonts.jetbrains-mono
  ] ++ lib.optionals isLinux [
    swaybg
    waypaper
  ]);

  home.file = {
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/hypr";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/nvim";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/waybar";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/ghostty";
    ".local/bin/bazel".source = "${pkgs.bazelisk}/bin/bazelisk";
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

  programs.hyprshot.enable = true;

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
    enableDefaultConfig = false;
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

  programs.asciinema.enable = true;
}
