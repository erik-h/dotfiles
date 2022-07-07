# If not running interactively then do nothing
[[ $- != *i* ]] && return

# Set up our general environment variables
# We do this in the profile as well as in the bashrc so that our environment
# is still set up for non-interactive commands.
# Reference: https://superuser.com/a/789499
test -f "$HOME/.environ" && . "$_"

## Shell prompt (aka PS1)
PS1="\u"
PS1+="\[$(tput setaf 2)\]@"
PS1+="\[$(tput sgr0)\]\H"
PS1+="\[$(tput setaf 2)\]\w"
PS1+="\[$(tput sgr0)\]"
PS1+=' $(parse_git_branch)\n'
PS1+="\[$(tput setaf 3)\]\$"
PS1+="\[$(tput sgr0)\] "
export PS1

#
# Below we set up any interactive shell specific environment variables and aliases
#

# Set the shell theme
# BASE16_SHELL="$HOME/.config/base16-shell/base16-eighties.dark.sh"
# test -s "$BASE16_SHELL" && source "$_"
# BASE16_SHELL="$HOME/.config/base16-shell/"
# test -n "$PS1" && test -s $BASE16_SHELL/profile_helper.sh && eval "$($_)"

# extends regexes
shopt -s extglob
# allows aliases over ssh
shopt -s expand_aliases

# Source bash aliases and functions
test -s "$HOME/.bash_aliases" && . "$_"
test -s "$HOME/.bash_functions" && . "$_"
test -s "$HOME/.local_bash_aliases" && . "$_"
test -s "$HOME/.local_bash_functions" && . "$_"
test -s "$HOME/.private-scripts/upto.sh" && . "$_"

## termite color setup
test -f ~/.dircolors && eval "$(dircolors "$_")"

## fzf: https://github.com/junegunn/fzf
test -f ~/.fzf.bash && . "$_"

## password-store
test -r "/usr/share/bash-completion/completions/pass" && . "$_"

## Node version manager setup
# export NVM_DIR="$HOME/.nvm"
# test -s "$NVM_DIR/nvm.sh" && . "$_"  # This loads nvm

# Source a local bashrc to add or overwrite things
test -f "$HOME/.local_bashrc" && . "$_"
test -s "$NVM_DIR/bash_completion" && . "$_"  # This loads nvm bash_completion

# Set up Nix env
test -e "$HOME/.nix-profile/etc/profile.d/nix.sh" &&  . "$_"

# Set up RVM
test -s "$HOME/.rvm/scripts/rvm" && . "$_" # Load RVM into a shell session *as a function*

# Start X11 if we log in on TTY1
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
	exec startx
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# SDKMAN! SDK manager configuration
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

