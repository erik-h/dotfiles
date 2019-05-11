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

# TODO: move all of this stuff to specific files, similar to how I currently
# set environment variables in ~/.environ for bash, etc.
if [ -d ~/.fzf ]
	set PATH ~/.fzf/bin $PATH
end
set SHELL /usr/bin/fish
# Make sure gpg pinentry will work from a tty
set GPG_TTY (tty)
