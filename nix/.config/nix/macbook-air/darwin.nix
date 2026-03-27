{ self, pkgs, ...}:

{
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        neovim
        pam-reattach
        vim
      ];

      users.users.erik = {
            name = "erik";
            home = "/Users/erik";
      };
      
      ids.gids.nixbld = 350;
      
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      
      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      homebrew = {
      	enable = true;
	casks = [
		"jagex"
		"mos"
		"proton-pass"
		"runelite"
		"zen-browser"
	];
	onActivation.cleanup = "zap";
      };

      security.pam.services.sudo_local.touchIdAuth = true;
      environment.etc."pam.d/sudo_local".text = ''
	  auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
	  auth       sufficient     pam_tid.so
      '';
      
      # Set Git commit hash for darwin-version.
      # system.configurationRevision = self.rev or self.dirtyRev or null;
      
      system.primaryUser = "erik";
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
      
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
}
