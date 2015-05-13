#!/usr/bin/env bash

DOTFILES_DIR="$HOME/.dotfiles"

if [ -d $HOME/.i3/ ]; then
	hasi3=true
else
	hasi3=false
fi

# function remove_files() {
# 	# Directories
# 	rm -f "$HOME/.vim/"
# 	rm -f "$HOME/.fonts/"
# 
# 	# Files
# 	rm -f "$HOME/.vimrc"
# 	rm -f "$HOME/.bashrc"
# 	rm -f "$HOME/.tmux.conf"
# 	rm -f "$HOME/.aliases"
# 	rm -f "$HOME/.zshrc"
# 	rm -f "$HOME/.i3status.conf"
# 
# 	if [ $hasi3 ]; then
# 		rm -f $HOME/.i3/config
# 	fi
# }

function link_files() {
	# Directories
	ln -s --backup=numbered "$DOTFILES_DIR/vim/" "$HOME/.vim";
	ln -s --backup=numbered "$DOTFILES_DIR/fonts/" "$HOME/.fonts";
	
	# Files
	if [ $hasi3 ]; then
		ln -s --backup=numbered "$DOTFILES_DIR/i3_config" "$HOME/.i3/config"
	fi
	ln -s --backup=numbered "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
	ln -s --backup=numbered "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"
	ln -s --backup=numbered "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
	ln -s --backup=numbered "$DOTFILES_DIR/aliases" "$HOME/.aliases"
	ln -s --backup=numbered "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
}

echo "Are you sure you want to replace your dotfiles with symbolic links to $DOTFILES_DIR ?"
read -r -p "Exisiting dotfiles will be backed up. [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
		# remove_files
		link_files
        ;;
	*)
		echo "Exiting..."
		exit
        ;;
esac
