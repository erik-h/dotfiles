function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

function reverse_history_search
  history | fzf --no-sort | read -l command
  if test $command
    commandline -rb $command
  end
end

function fish_user_key_bindings
    bind ! bind_bang
    bind '$' bind_dollar

	bind \cr reverse_history_search
end

# Disable the greeting
set fish_greeting

# Show the _full path_ in `fish_prompt`
set fish_prompt_pwd_dir_length 0

# Set up our general environment variables
source ~/.config/fish/env/env.fish

# Initialize pyenv
# TODO: only run this if pyenv is installed...
#pyenv init - | source

# Install fisher for fish package management
if not functions -q fisher
	set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
	curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
	fish -c fisher
end

# Start X11 if we log in on TTY1
if [ -z "$DISPLAY" ]; and [ (tty) = "/dev/tty1" ]
	exec startx
end
