{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader settings
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
    pname = "distro-grub-themes";
    version = "3.1";
    src = pkgs.fetchFromGitHub {
      owner = "AdisonCavani";
      repo = "distro-grub-themes";
      rev = "v3.1";
      hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
    };
    installPhase = "cp -r customize/nixos $out";
  };

 
  #to load ntfs file system
  boot.supportedFilesystems = [ "ntfs" ];

  #nix-flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking configuration
  networking.hostName = "nixos";  # Define hostname
  networking.networkmanager.enable = true;  # Enable NetworkManager for easier management

  # Time zone and locale settings
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable Hyprland as the default session in X server
  services.displayManager.defaultSession = "hyprland";

  # Configure keyboard layout
  services.xserver = {
    enable = true;
    xkb.layout = "in";
    xkb.variant = "eng";
    videoDrivers = ["nvidia"];  # Use NVIDIA drivers  
  };

  # Enable libinput for touchpad/mouse support
  services.libinput.enable = true;  

  # Printing services
  services.printing.enable = true;

  # Sound system with Pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration
  users.users.asura = {
    isNormalUser = true;
    description = "asura";
    extraGroups = [ "networkmanager" "wheel" "storage" "audio" ]; # Added 'audio' group for sound
    packages = with pkgs; [
      # Additional user packages can be added here
    ];
  };

  # Enable automatic login for user 'asura'
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "asura";

  # Fix for GNOME auto-login
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install Firefox browser
  programs.firefox.enable = true;

  # Allow unfree packages (required for NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  # System-wide packages and tools
  environment.systemPackages = with pkgs; [
    # Essential tools
    lxqt.lxqt-openssh-askpass #for git 
    gnome.seahorse
    lf
    bc
    waybar
    pamixer
    pavucontrol
    dunst
    swaybg
    kitty
    konsole
    wofi
    playerctl
    nerdfonts
    firefox-wayland
    wlroots
    xdg-desktop-portal-hyprland
    pcmanfm
    vscode
    polkit
    lxqt.lxqt-policykit
    neofetch
    xarchiver
    rofi-wayland
    telegram-desktop
    android-tools
    numix-icon-theme
    fish
    vlc
    wlogout
    git
    python3
    udisks2
    gvfs
    xfce.thunar
    xfce.thunar-volman
    swww
    # Waybar with experimental features
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
  ];

  #for git 
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };
  programs.seahorse.enable = true;

  # Hyprland-specific configurations
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #enableNvidiaPatches = true;  
  };

  # Set environment variables for Wayland
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";  # Fix invisible cursor
    NIXOS_OZONE_WL = "1";  # Enable Wayland in some apps like Chrome
  };

  # XDG Portals for better Wayland compatibility
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Fonts configuration
  fonts.packages = with pkgs; [
    fira
    fira-code-symbols
    nerdfonts
  ];
  fonts.fontconfig.enable = true;

  # Enable dark theme (GTK and Qt)
  environment.variables = {
    GTK_THEME = "Adwaita-dark";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  
  # Qt theme settings
  qt.platformTheme = "qt5ct";


  # NVIDIA driver configuration
  hardware.opengl = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem pkg [
      "nvidia_x11"
    ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;  # Use proprietary NVIDIA driver
    nvidiaSettings = true;  # Enable NVIDIA settings tool
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Garbage collection to clean unused packages
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Automatic system updates from NixOS 24.05 channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-24.05";
  };

  # System state version
  system.stateVersion = "24.05";
}
