# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options, and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in

{
  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.jada = import ./home.nix;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true; # ew
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixiu"; # Define hostname. 
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.xserver = {
	enable=true;
	windowManager.qtile.enable=true;
	displayManager.sessionCommands = ''
		xwallpaper --zoom ~/home-manager-dotfiles/walls/wallpaper.png
		xset r rate 200 35 &
	'';
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire.enable=true;
  services.libinput.enable = true;
  services.picom = {
	enable=true;
	backend="glx";
	fade=false;
  };

  users.users.jada = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
	vim
	wget
	python3
	btop
	fastfetch
	git
	gedit
	alacritty
	ffmpeg
	libpng
	libjpeg
	libxcb
	brightnessctl
	xwallpaper
	xbacklight
	arandr
	alsa-utils
	sonixd
	pcmanfm
	rofi
	spotify
	steam-unwrapped
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
               "spotify" "steam-unwrapped"
             ];

  fonts.packages = with pkgs; [
	jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Do NOT change this value.
  system.stateVersion = "26.05"; # Did you read the comment?

}

