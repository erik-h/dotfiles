{
  description = "Erik's nix-darwin system flake";

  inputs = {
    claude-code-nix = {
    	url = "github:sadjow/claude-code-nix";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
    	url = "github:hraban/mac-app-util";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, claude-code-nix, homebrew-core, homebrew-cask, home-manager, mac-app-util, ... }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Eriks-MacBook-Air
    darwinConfigurations."Eriks-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [
      	{
		nixpkgs.config.allowUnfree = true;
	}
	mac-app-util.darwinModules.default
        ./darwin.nix
	nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "erik";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        # Optional: Align homebrew taps config with nix-homebrew
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
	  home-manager.extraSpecialArgs = {
	  	claude-code = claude-code-nix.packages.aarch64-darwin.claude-code;
	  };
          home-manager.users.erik = ./home.nix;
          home-manager.sharedModules = [
		mac-app-util.homeManagerModules.default
          ];
        }
      ];
    };
  };
}
