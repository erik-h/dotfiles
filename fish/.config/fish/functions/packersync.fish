function packersync --description 'Perform a :PackerSync in headless neovim'
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
end
