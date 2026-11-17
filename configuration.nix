# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # System: DO NOT CHANGE
  system.stateVersion = "26.05";


  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Gnome
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    baobab 
    cheese 
    epiphany 
    geary 
    gnome-connections 
    gnome-maps 
    gnome-tour 
    gnome-weather 
    seahorse
    simple-scan 
    snapshot
    yelp 
  ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };


  # Hardware + Audio
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.xone.enable = true; # Xbox Controller

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Package setup
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import (fetchTarball {
        url = "https://github.com/Nixos/nixpkgs/archive/nixos-unstable.tar.gz";
      }) {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  # System-wide core packages
  environment.systemPackages = with pkgs; [
    curl 
    docker-compose
    fd 
    fzf 
    gcc 
    git 
    gnome-tweaks 
    gnomeExtensions.appindicator 
    gnomeExtensions.system-monitor
    gnumake 
    go 
    luarocks 
    neovim 
    p7zip 
    rclone
    ripgrep 
    unzip 
    wget 
  ];


  # Accounts ; Usersoftware
  users.users."thierry" = {
    isNormalUser = true;
    description = "Thierry Jegen";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # Applications
      bruno 
      chromium
      dbeaver-bin 
      discord 
      obsidian 
      remmina 
      shotwell 
      signal-desktop 
      thunderbird 

      # Development
      nodejs_26
      opencode 
      unstable.jetbrains-toolbox 
      vscodium 
      zed-editor 

      # Media & Gaming
      mangohud 
      protonup-qt
      yt-dlp 
    ];
  };

  users.defaultUserShell = "${pkgs.zsh}/bin/zsh";
  environment.shells = with pkgs; [ zsh ];


  # ZSH ; Env
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "lukerandall";
      plugins = [ "git" "fzf" "ssh-agent" ];
    };
    
    shellAliases = {
      ytdl = "yt-dlp -f bestaudio -x --audio-format flac --embed-thumbnail --embed-metadata -o '%(title)s.%(ext)s'";
      proton-sync = "rclone sync protondrive: /home/thierry/ProtonDrive --progress --exclude \"/Backups/**\"";
      vim = "nvim";
    };
    
    interactiveShellInit = ''
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh

      zstyle :omz:plugins:ssh-agent lifetime 4h
      zstyle :omz:plugins:ssh-agent identities id_ed25519 server_default
      zstyle ':omz:update' mode auto
      zstyle ':omz:update' frequency 5

      HIST_STAMPS="dd.mm.yyyy"

      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='vim'
      else
        export EDITOR='nvim'
      fi
    '';
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/thierry/.steam/root/compatibilitytools.d";
    FZF_DEFAULT_OPTS = ''
      --border='rounded' \
      --preview-window='border-rounded' \
      --prompt='❯ ' \
      --marker='❯ ' \
      --pointer='➜ ' \
      --separator='─' \
      --scrollbar='│' \
      --color='fg:#abb2bf,fg+:#ffffff,bg:#282c34,bg+:#31353f' \
      --color='hl:#e06c75,hl+:#e5c07b,info:#61afef' \
      --color='marker:#98c379,prompt:#61afef,spinner:#c678dd,pointer:#c678dd' \
      --color='header:#e5c07b,border:#61afef,label:#61afef' \
      --color='separator:#3e4451,scrollbar:#61afef'
    '';
  };


  # Programs ; Gaming ; Docker ; Flatpak
  programs.firefox.enable = true;
  programs.chromium = {
    enable = true;
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh"
      "nngceckbapebfimnlniiiahkandclblb"
    ];
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  virtualisation.docker.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # Requirements for Jetbrains Products
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    atk
    cairo
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    libXxf86vm
    zlib
  ];


  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
