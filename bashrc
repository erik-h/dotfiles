#if [ "$TMUX" = "" ]; then tmux; fi
#cat /home/mint/.ascii
alias la="ls -a"
alias rmi="rm -i"
alias cpi="cp -i"
alias mvi="mv -i"
alias open="xdg-open"
alias tmux="tmux -2" # Force tmux to 256 colors
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias sl="sl -e"
alias lock="xscreensaver-command -l"
alias nemo="nemo --no-desktop"
alias mupdf="mupdf-x11"

export PS1="\[\e[00;37m\]\u\[\e[0m\]\[\e[00;32m\]@\[\e[0m\]\[\e[00;37m\]\H:\[\e[0m\]\[\e[00;32m\]\w\[\e[0m\]\[\e[00;37m\]\n\[\e[0m\]\[\e[00;33m\]\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"
#fortune | cowthink | lolcat
