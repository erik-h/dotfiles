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
BASE16_SHELL="$HOME/.config/base16-shell/base16-eighties.dark.sh"
test -s "$BASE16_SHELL" && source "$_"

# extends regexes
shopt -s extglob
# allows aliases over ssh
shopt -s expand_aliases

# Source bash aliases and functions
test -s "$HOME/.bash_aliases" && . "$_"
test -s "$HOME/.bash_functions" && . "$_"
test -s "$HOME/.local_bash_aliases" && . "$_"
test -s "$HOME/.local_bash_functions" && . "$_"
test -s "$HOME/.scripts/upto.sh" && . "$_"

## termite color setup
test -f ~/.dircolors && eval "$(dircolors "$_")"

## fzf: https://github.com/junegunn/fzf
test -f ~/.fzf.bash && . "$_"

## Node version manager setup
export NVM_DIR="$HOME/.nvm"
test -s "$NVM_DIR/nvm.sh" && . "$_"  # This loads nvm

# Source a local bashrc to add or overwrite things
[ -f "$HOME/.local_bashrc" ] && . "$HOME/.local_bashrc"
