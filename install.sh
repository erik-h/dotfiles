#!/usr/bin/env bash

DOTFILES_DIR="$HOME/.dotfiles"

function link_all() {
	# Directories
	ln -s --backup=numbered "$DOTFILES_DIR/vim" "$HOME/.vim";
	ln -s --backup=numbered "$DOTFILES_DIR/fonts" "$HOME/.fonts";
	ln -s --backup=numbered "$DOTFILES_DIR/i3" "$HOME/.i3"

	# Files
	ln -s --backup=numbered "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
	ln -s --backup=numbered "$DOTFILES_DIR/pentadactylrc" "$HOME/.pentadactylrc"

	ln -s --backup=numbered "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
	ln -s --backup=numbered "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"
	ln -s --backup=numbered "$DOTFILES_DIR/aliases" "$HOME/.aliases"

	ln -s --backup=numbered "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
	ln -s --backup=numbered "$DOTFILES_DIR/i3status.conf" "$HOME/.i3status.conf"

}

echo "Are you sure you want to replace your dotfiles with symbolic links to $DOTFILES_DIR ?"
read -r -p "Exisiting dotfiles will be backed up. [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
		link_all
        ;;
	*)
		echo "Exiting..."
		exit
        ;;
esac
