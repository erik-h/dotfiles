# Always run tmux
#if [ "$TMUX" = "" ]; then tmux; fi

if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

export EDITOR="vim"
export PS1="\[\e[00;37m\]\u\[\e[0m\]\[\e[00;32m\]@\[\e[0m\]\[\e[00;37m\]\H:\[\e[0m\]\[\e[00;32m\]\w\[\e[0m\]\[\e[00;37m\]\n\[\e[0m\]\[\e[00;33m\]\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"
