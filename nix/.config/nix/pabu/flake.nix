{
	description = "Hyprland on NixOS";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser = {
			url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		xremap-flake = {
			url = "github:xremap/nix-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
		nixosConfigurations.pabu = nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.erik = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
				inputs.xremap-flake.nixosModules.default
				{
					services.xremap = {
						enable = true;
						withWlroots = true;
						config = {
							modmap = [
								{
									name = "Global";
									remap = {
										"CapsLock" = {
											"held" = "Ctrl_L";
											"alone" = "Esc";
											"alone_timeout" = "500";
										};
									};
								}
							];
						};
					};
				}
			];
		};
	};
}
