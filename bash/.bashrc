# TODO:
# - Move environment variable stuff into .profile; it only needs to be set once,
#   not every time we spawn a new shell.
# - Move machine specific PATH modificiations to a `~/.local_profile`, sourced
#   if it exists in `~/.profile`.

# If not running interactively then do nothing
[[ $- != *i* ]] && return

BASE16_SHELL="$HOME/.config/base16-shell/base16-eighties.dark.sh"
[ -s $BASE16_SHELL ] && source $BASE16_SHELL

# extends regexes
shopt -s extglob
# allows aliases over ssh
shopt -s expand_aliases

## TODO: Here (and everywhere) use `test` instead of `[]` so that
## I can go `test -f "/foo/bar.sh" && . $_`
# Source bash aliases and functions
[ -f "$HOME/.bash_aliases" ] && . $HOME/.bash_aliases
[ -f "$HOME/.bash_functions" ] && . $HOME/.bash_functions
[ -f "$HOME/.local_bash_aliases" ] && . $HOME/.local_bash_aliases
[ -f "$HOME/.scripts/upto.sh" ] && . $HOME/.scripts/upto.sh

# Add some directories with binaries to my PATH if they exist
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.local/sbin" ] && PATH="$HOME/.local/sbin:$PATH"
[ -d "$HOME/.scripts" ] && PATH="$HOME/.scripts:$PATH"
# Custom gradle install
[ -d "$HOME/Downloads/gradle-3.5/bin" ] && PATH="$HOME/Downloads/gradle-3.5/bin:$PATH"

[ -d "$HOME/node_modules" ] && PATH="$HOME/node_modules/.bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.gem/ruby/2.3.0/bin" ] && PATH="$HOME/.gem/ruby/2.3.0/bin:$PATH"

# CUDA
[ -d "/usr/local/cuda-8.0/bin/" ] && PATH="/usr/local/cuda-8.0/bin/:$PATH"

## Include library paths for locally installed stuff
LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" # Apparently this directory isn't always included by default
# TODO: add a `test -d` here to only add to LD_LIBRARY_PATH if exists
LD_LIBRARY_PATH="$HOME/.local/lib/:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH
export LIBRARY_PATH="$HOME/.local/lib/:$LIBRARY_PATH"

# Hide commands prefixed with spaces
export HISTCONTROL="ignorespace"

# Set some default programs
export EDITOR="vim"
if [[ "$(hostname)" =~ ^[L119|N221].* ]]; then
	BROWSER="google-chrome"
else
	# BROWSER="chromium"
	BROWSER="google-chrome"
fi
export BROWSER
# Change the default man pager to vim
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

###############
#  START PS1  #
###############

# TODO: Put parse_git_branch and the $? status in a seperate script. This is needed
# if I want $? to be after, because parse_git_branch will set $?.
PS1="\u"
PS1+="\[$(tput setaf 2)\]@"
PS1+="\[$(tput sgr0)\]\H"
PS1+="\[$(tput setaf 2)\]\w"
PS1+="\[$(tput sgr0)\]"
PS1+=' $(parse_git_branch)\n'
PS1+="\[$(tput setaf 3)\]\$"
PS1+="\[$(tput sgr0)\] "

export PS1
#############
#  END PS1  #
#############

# Environment variables for golang
export GOROOT="$HOME/dev/lang/go"
PATH="$PATH:$GOROOT/bin"
export GOPATH="$HOME/dev/go"
PATH="$PATH:$GOPATH/bin"

## Add Tomcat servlet api to CLASSPATH
[ -d /usr/share/java ] && CLASSPATH="/usr/share/java/tomcat-servlet-api-3.0.jar:$CLASSPATH"

## Use alternatively installed java8
[ -d /opt/jdk/jdk1.8.0_65/bin/ ] && PATH="/opt/jdk/jdk1.8.0_65/bin/:$PATH"

## termite color setup
[ -f ~/.dircolors ] && eval $(dircolors ~/.dircolors)

## bspwm
# Add my bspwm scripts to my PATH
[ -d "$HOME/.config/bspwm/scripts" ] && PATH="$HOME/.config/bspwm/panel/scripts:$PATH"

## ranger
# load custom config file, not the default
export RANGER_LOAD_DEFAULT_RC=false

## fzf: https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## Neovim
# Fix colors (default $TERM is xterm)
# [[ "$(hostname)" =~ ^[L119|N221].* ]] && export TERM=xterm-256color
# [ -n "$SSH_CONNECTION" ] && export TERM=xterm-256color
# Use locally installed neovim if exists
[ -d "$HOME/neovim/bin" ] && PATH="$HOME/neovim/bin:$PATH"

# Set TERM so we don't get weird stuff happening in tmux
export TERM=screen-256color

# Add local install of jdk 8 to my PATH
[ -d ~/.local/bin/jdk1.8.0_60/bin ] && PATH="$HOME/bin/jdk1.8.0_60/bin:$PATH"

# Make sure default config folder is set
[ -d ~/.config ] && export XDG_CONFIG_HOME="$HOME/.config/"

# Ruby gem binaries
[ -d ~/.gem/ruby/2.2.0/bin ] && PATH="$PATH:$HOME/.gem/ruby/2.2.0/bin"
[ -d ~/.gem/ruby/1.9.1/bin ] && PATH="$PATH:$HOME/.gem/ruby/1.9.1/bin"

# Sort-of-not-really working fix for weird javax.swing issues in bspwm
export _JAVA_AWT_WM_NONREPARENTING=1

export PATH
export CLASSPATH

## Node version manager setup
export NVM_DIR="/home/erik/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Source a local bashrc to add or overwrite things
[ -f "$HOME/.local_bashrc" ] && . $HOME/.local_bashrc
