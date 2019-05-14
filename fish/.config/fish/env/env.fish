#
# In this script we set up global environment variables
#

if [ -n "$_FISH_ENV_SOURCED" ]
	# We've already sourced this environment script, so let's exit!
	exit 0
else
	# We haven't sourced this environment script yet; we will set an
	# environment variable flag to ensure we don't source it again and we
	# will ... source it now!
	set -x _FISH_ENV_SOURCED "true"
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

# Set TERM so we don't get weird stuff happening in tmux
set -x TERM screen-256color

# Make sure gpg pinentry will work from a tty
set -x GPG_TTY (tty)


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
[ -d "$HOME/.fzf" ]; and set -x PATH ~/.fzf/bin $PATH
# Binaries installed with `snap`
[ -d "/snap/bin" ]; and set -x PATH "/snap/bin" $PATH
# General binaries
[ -d "$HOME/bin" ]; and set -x PATH "$HOME/bin" $PATH
[ -d "$HOME/.local/bin" ]; and set -x PATH "$HOME/.local/bin" $PATH
[ -d "$HOME/.local/sbin" ]; and set -x PATH "$HOME/.local/sbin" $PATH
[ -d "$HOME/.private-scripts" ]; and set -x PATH "$HOME/.private-scripts" $PATH
# Language specific binaries
# Golang
[ -d "$GOROOT/bin" ]; and set -x PATH $PATH "$GOROOT/bin"
[ -d "$GOPATH/bin" ]; and set -x PATH $PATH "$GOPATH/bin"
# Nodejs
[ -d "$HOME/node_modules/.bin" ]; and set -x PATH "$HOME/node_modules/.bin" $PATH
# Rust
[ -d "$HOME/.cargo/bin" ]; and set -x PATH "$HOME/.cargo/bin" $PATH
# Ruby
[ -d "$HOME/.rvm/bin" ]; and set -x PATH "$HOME/.rvm/bin" $PATH

## Library paths
# TODO: grep for /usr/local/lib before trying to add it so I don't get a double entry
set -x LD_LIBRARY_PATH "/usr/local/lib" $LD_LIBRARY_PATH # Apparently this directory isn't always included by default
# Include library paths for locally installed stuff
[ -d "$HOME/.local/lib/" ]; and set -x LD_LIBRARY_PATH "$HOME/.local/lib/" $LD_LIBRARY_PATH; and set -x LIBRARY_PATH "$HOME/.local/lib/" $LIBRARY_PATH

# Use a dmenu password prompt script
# [ -f "$HOME/.private-scripts/dpass" ] && export SUDO_ASKPASS="$HOME/.private-scripts/dpass"

# If we have a faster searcher than `find` installed, use it for fuzzy
# file finding
if command -v rg > /dev/null 2>&1
	set -x FZF_DEFAULT_COMMAND "rg --hidden --files"
else if command -v ag > /dev/null 2>&1
	set -x FZF_DEFAULT_COMMAND "ag --hidden --ignore .git -g ''"
end

[ -f "$HOME/.config/fish/env/local_env.fish" ]; and source "$HOME/.config/fish/env/local_env.fish"
