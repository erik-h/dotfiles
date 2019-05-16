#
# In this script we set up global environment variables
#

function _path_munge -d "Add the given directory to \$PATH if it isn't already in there."
	set -l candidate $argv[1]
	set -l modifier $argv[2]

	switch "$PATH"
	case "*$candidate*"
		return 1
	case '*'
		if [ "$modifier" = "after" ]
			# TODO
			set -gx PATH $PATH $candidate
		else
			set -gx PATH $candidate $PATH
		end
		return 0
	end
end

function _ld_library_path_munge -d "Add the given directory to \$LD_LIBRARY_PATH if it isn't already in there."
	set -l candidate $argv[1]
	set -l modifier $argv[2]

	switch "$LD_LIBRARY_PATH"
	case "*$candidate*"
		return 1
	case '*'
		if [ "$modifier" = "after" ]
			# TODO
			set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $candidate
		else
			set -gx LD_LIBRARY_PATH $candidate $LD_LIBRARY_PATH
		end
		return 0
	end
end

function first_installed -d "Return the first 'installed' (i.e. in \$PATH) command of the given args."
	for cmd in $argv
		if command -v $cmd > /dev/null 2>&1
			echo $cmd
			return 0
		end
	end

	echo ""
	return 1
end

set -x SHELL /usr/bin/fish

# Make sure gpg pinentry will work from a tty
set -x GPG_TTY (tty)

# Set TERM so we don't get weird stuff happening in tmux
set -x TERM screen-256color

## Set some default programs
set -x TERMINAL (first_installed "termite" "gnome-terminal" "xterm")
set -x EDITOR "vim"
set -x BROWSER "firefox"
set -x MANPAGER "/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# Hide commands prefixed with spaces
set -x HISTCONTROL "ignorespace"
# Include execution time in command history
set -x HISTTIMEFORMAT '%F %T '

# Make sure default config folder is set
set -x XDG_CONFIG_HOME "$HOME/.config"

## Language specific environment variables
# Golang
set -x GOROOT "$HOME/dev/lang/go"
set -x GOPATH "$HOME/dev/go"
# Android
set -x ANDROID_HOME "$HOME/opt/Android/sdk"

## Program specific environment variables
# load custom ranger config file, not the default
set -x RANGER_LOAD_DEFAULT_RC false
# set location for ripgrep config file
set -x RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/ripgreprc"

# password-store
set -x PASSWORD_STORE_ENABLE_EXTENSIONS "true"

## PATH
# FZF
# [ -d "$HOME/.fzf" ]; and set -x PATH ~/.fzf/bin $PATH
[ -d "$HOME/.fzf" ]; and _path_munge ~/.fzf/bin
# Binaries installed with `snap`
[ -d "/snap/bin" ]; and _path_munge "/snap/bin"
# General binaries
[ -d "$HOME/bin" ]; and _path_munge "$HOME/bin"
[ -d "$HOME/.local/bin" ]; and _path_munge "$HOME/.local/bin"
[ -d "$HOME/.local/sbin" ]; and _path_munge "$HOME/.local/sbin"
[ -d "$HOME/.private-scripts" ]; and _path_munge "$HOME/.private-scripts"
# Language specific binaries
# Golang
[ -d "$GOROOT/bin" ]; and _path_munge "$GOROOT/bin"
[ -d "$GOPATH/bin" ]; and _path_munge "$GOPATH/bin"
# Nodejs
[ -d "$HOME/node_modules/.bin" ]; and _path_munge "$HOME/node_modules/.bin"
# Rust
[ -d "$HOME/.cargo/bin" ]; and _path_munge "$HOME/.cargo/bin"
# Ruby
[ -d "$HOME/.rvm/bin" ]; and _path_munge "$HOME/.rvm/bin"

## Library paths
# TODO: grep for /usr/local/lib before trying to add it so I don't get a double entry
_ld_library_path_munge "/usr/local/lib" # Apparently this directory isn't always included by default
# Include library paths for locally installed stuff
[ -d "$HOME/.local/lib/" ]; and _ld_library_path_munge "$HOME/.local/lib/"; and _ld_library_path_munge "$HOME/.local/lib/"

# Use a dmenu password prompt script
# [ -f "$HOME/.private-scripts/dpass" ] && export SUDO_ASKPASS="$HOME/.private-scripts/dpass"

# If we have a faster searcher than `find` installed, use it for fuzzy
# file finding
if command -v rg > /dev/null 2>&1
	set -x FZF_DEFAULT_COMMAND "rg --hidden --files"
else if command -v ag > /dev/null 2>&1
	set -x FZF_DEFAULT_COMMAND "ag --hidden --ignore .git -g ''"
end

functions -e _path_munge
functions -e _ld_library_path_munge

[ -f "$HOME/.config/fish/env/local_env.fish" ]; and source "$HOME/.config/fish/env/local_env.fish"
