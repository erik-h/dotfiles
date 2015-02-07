#!/usr/bin/env bash

DOTFILES_DIR="$HOME/Programming/github/dotfiles"

function remove_files() {
	# Directories
	rm "$HOME/.vim/" || true
	rm "$HOME/.fonts/" || true

	# Files
	rm "$HOME/.vimrc" || true
	rm "$HOME/.bashrc" || true
	rm "$HOME/.tmux.conf" || true
	rm "$HOME/.aliases" || true
	rm "$HOME/.zshrc" || true
}

function link_files() {
	# Directories
	if [ ! -d $HOME/.vim/ ]; then ln -s "$DOTFILES_DIR/vim/" "$HOME/.vim"; fi
	if [ ! -d $HOME/.fonts/ ]; then ln -s "$DOTFILES_DIR/fonts/" "$HOME/.fonts"; fi
	

	# Files
	ln -s "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
	ln -s "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"
	ln -s "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
	ln -s "$DOTFILES_DIR/aliases" "$HOME/.aliases"
	ln -s "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
}

read -r -p "Are you sure you want to replace your dotfiles with symbolic links to $DOTFILES_DIR ? [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
		remove_files
		link_files
        ;;
	*)
		echo "Exiting..."
		exit
        ;;
esac
