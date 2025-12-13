{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  hardware.bluetooth.enable = true;
  services.pipewire.enable = true;
  boot.loader = {
    grub = {
      device = "nodev";
      enable = true;
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  services.getty.autologinUser = "erik";
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.hypridle.enable = true;
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.hostName = "pabu";
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;
  # users.users.root.hashedPassword = "...";
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

 
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    btop
    ghostty
    git
    google-chrome
    hyprpaper
    hyprlock
    neovim
    overskride
    pavucontrol
    ripgrep
    vesktop
    waybar
    wofi
    wget
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    font-awesome_6
    fira-code
    fira-code-symbols
  ];
  time.timeZone = "America/Denver";
  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];
  users.users.erik = {
	isNormalUser = true;
	extraGroups = [
		"wheel"
		"networkmanager"
		"input"
	];
	packages = with pkgs; [
		bat
		tree
		inputs.zen-browser.packages."${system}".twilight
	];
	shell = pkgs.fish;
  };
  system.stateVersion = "25.11";
}
