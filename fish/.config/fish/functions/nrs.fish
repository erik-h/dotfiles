function nrs --description 'nix-rebuild/darwin-rebuild switch'
	if test (uname) = Darwin
		sudo darwin-rebuild switch --flake ~/.config/nix
	else
		sudo nix-rebuild switch --flake ~/.config/nix
	end
end
