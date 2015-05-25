# Always run tmux
#if [ "$TMUX" = "" ]; then tmux; fi

shopt -s extglob # extends regexes

if [ -f "$HOME/.aliases" ]; then
	. $HOME/.aliases
fi

if [ -f "$HOME/.local_aliases" ]; then
	. $HOME/.local_aliases
fi

if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/node_modules" ]; then
	PATH="$HOME/node_modules/.bin:$PATH"
fi

if [ -d "$HOME/Downloads/gradle-2.4-bin/bin" ]; then
	PATH="$HOME/Downloads/gradle-2.4-bin/bin:$PATH"
fi

export HISTCONTROL="ignorespace"
export EDITOR="vim"
export PS1="\[\e[00;37m\]\u\[\e[0m\]\[\e[00;32m\]@\[\e[0m\]\[\e[00;37m\]\H:\[\e[0m\]\[\e[00;32m\]\w\[\e[0m\]\[\e[00;37m\]\n\[\e[0m\]\[\e[00;33m\]\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

export NVM_DIR="/home/erik/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
