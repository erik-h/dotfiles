{ config, pkgs, ... }:

{
	home.username = "erik";
	home.homeDirectory = "/home/erik";
	home.stateVersion = "25.11";
	home.sessionVariables = {
		BROWSER = "zen";
	};
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use Hyprland btw";
			nrs = "nixos-rebuild switch --sudo";
			sudo = "sudo ";
			vim = "nvim";
		};
		profileExtra = ''
			if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
				exec hyprland
			fi
		'';
	};
	programs.fish = {
		enable = true;
		shellAliases = {
			nrs = "nixos-rebuild switch --sudo";
			sudo = "sudo ";
			vim = "nvim";
		};
		interactiveShellInit = ''
			if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ];
				exec hyprland
			end
		'';
	};
}
