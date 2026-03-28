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
		"deskflow"
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

      services.tailscale.enable = true;
      services.aerospace = {
      	enable = true;
	settings = {
	    gaps = {
	      outer.left = 8;
	      outer.bottom = 8;
	      outer.top = 8;
	      outer.right = 8;
	      inner.horizontal = 8;
	      inner.vertical = 8;
	    };
	    mode.main.binding = {
	      "cmd-h" = "focus left";
	      "cmd-j" = "focus down";
	      "cmd-k" = "focus up";
	      "cmd-l" = "focus right";
	      "cmd-shift-h" = "move left";
	      "cmd-shift-j" = "move down";
	      "cmd-shift-k" = "move up";
	      "cmd-shift-l" = "move right";
	      "cmd-shift-f" = "fullscreen";
	      # workspaces
	      "cmd-1" = "workspace 1";
	      "cmd-2" = "workspace 2";
	      "cmd-3" = "workspace 3";
	      "cmd-shift-1" = "move-node-to-workspace 1";
	      "cmd-shift-2" = "move-node-to-workspace 2";
	      "cmd-shift-3" = "move-node-to-workspace 3";
	    };
	  };
      };
      
      # Set Git commit hash for darwin-version.
      # system.configurationRevision = self.rev or self.dirtyRev or null;
      
      system.primaryUser = "erik";
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
      
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
}
