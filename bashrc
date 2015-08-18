# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White




# Always run tmux
#if [ "$TMUX" = "" ]; then tmux; fi

shopt -s extglob # extends regexes

if [ -f "$HOME/.local_bashrc" ]; then
	. $HOME/.local_bashrc
fi

# Only set aliases if I'm in an interactive session
if [[ $- == *i* ]]; then
	if [ -f "$HOME/.aliases" ]; then
		. $HOME/.aliases
	fi

	if [ -f "$HOME/.local_aliases" ]; then
		. $HOME/.local_aliases
	fi
fi

if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/local/bin" ]; then
	PATH="$HOME/local/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/node_modules" ]; then
	PATH="$HOME/node_modules/.bin:$PATH"
fi

if [ -d "$HOME/Downloads/gradle-2.4-bin/bin" ]; then
	PATH="$HOME/Downloads/gradle-2.4-bin/bin:$PATH"
fi

if [ -d "$HOME/eclipse" ]; then
	PATH="$HOME/eclipse:$PATH"
fi

export HISTCONTROL="ignorespace"
export EDITOR="vim"

# Change the default man pager to vim
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# Only set my PS1 if I'm in an interactive session
if [[ $- == *i* ]]; then
	###############
	#  START PS1  #
	###############

	PS1="\u"
	PS1+="\[$(tput setaf 2)\]@"
	PS1+="\[$(tput sgr0)\]\H"
	PS1+="\[$(tput setaf 2)\]\w"
	PS1+="\[$(tput sgr0)\]"
	PS1+=' $(parse_git_branch)\n'
	PS1+="\[$(tput setaf 3)\]\$"
	PS1+="\[$(tput sgr0)\] "

	# Below is the old broken version
	# PS1="\[${White}\]"
	# PS1="$PS1\u"
	# PS1="$PS1\[${Green}\]"
	# PS1="$PS1@"
	# PS1="$PS1\[${White}\]"
	# PS1="$PS1\H"
	# PS1="$PS1\[${Green}\]"
	# PS1="$PS1\w"
	# PS1="$PS1\[${White}\]"
	# # PS1='$(__git_ps1)\n'
	# PS1=' $(parse_git_branch)\n'
	# PS1="$PS1\[${Yellow}\]"
	# PS1="$PS1\$"
	# PS1="$PS1\[${Color_Off}\]"
	# PS1="$PS1 "


	# export PS1="${White}\u${Green}@${White}\H:${Green}\w${White} $(__git_ps1)\n${Yellow}\$ ${Color_Off}"
	# export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

	export PS1
	#############
	#  END PS1  #
	#############
fi

export NVM_DIR="/home/erik/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# This is the git prompt method from github.com/git/git/
# source ~/.dotfiles/git-prompt.sh

# Environment variables for golang
export GOROOT="$HOME/Programming/lang/go"
export PATH="$PATH:$GOROOT/bin"

export GOPATH="$HOME/Programming/go"
export PATH="$PATH:$GOPATH/bin"

export PATH="$PATH:$HOME/.config/bspwm/panel"

# termite
[ -f ~/.dircolors ] && eval $(dircolors ~/.dircolors)

# bspwm
export PATH="$PATH:$HOME/.config/bspwm/panel:$HOME/.config/bspwm/scripts"
export RANGER_LOAD_DEFAULT_RC=false

# fzf: https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Neovim
if [ -d "$HOME/neovim/bin" ]; then
	export PATH="$PATH:$HOME/neovim/bin"
fi
