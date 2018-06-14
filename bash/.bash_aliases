# This alias can be used after a command to be alerted of its completion.
# e.g. `sleep 30; alert`
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit my inbox orgmode file
alias inbox="vim ~/.org/inbox.org"

function x2xattach() {
	[[ $# -ne 2 ]] && { >&2 echo "Usage: x2xattach <remote host> <compass direction>"; return 1; }
	ssh -Y "$1" "x2x -$2 -to :0"
}

# Ping one of Google's DNS servers to check if I have internet connectivity
alias gping="ping 8.8.8.8"

alias cdtemp="cd $(mktemp -d)"

# Get this machine's network's public IP address
alias publicip="dig TXT +short o-o.myaddr.1.google.com @ns1.google.com | sed 's/\"//g'"

# Allow aliases to be sudo-ed
alias sudo="sudo "

function cdrand() {
	shopt -s nullglob
	dirs=(*/)
	[[ $dirs ]] && cd -- "${dirs[RANDOM % ${#dirs[@]}]}"
}

alias htopme="htop -u \$USER"
alias upgrade="sudo apt update && sudo apt upgrade"

alias drawio="google-chrome --app-id=pebppomjfocnoigkeepgbmcifnnlndla &>/dev/null &"

alias qb="qutebrowser"

function numframes() {
	ffprobe -select_streams v -show_streams "$1" 2>/dev/null | grep nb_frames | sed -e 's/nb_frames=//'
}

alias vim="vim"
alias vimagit="vim +MagitOnly "
alias goyo="vim +Goyo +Limelight "

alias exa="exa -s Name" # sort like ls does by default

alias tree="tree -C"
function treeless() {
	\tree -C $@ | less -r
}

# Useful aliases and functions for summer research
alias daydir="mkdir \$(date +'%Y-%m-%d')"
alias dircount="find ./* -maxdepth 0 -type d | wc -l"
alias filecount="find ./* -maxdepth 0 -type f | wc -l"
function tardir() {
	tar --remove-files -czf ${1%/*}.tar.gz $1
}

# Execute a command in the background then immediately exit the shell
function ebg() {
	("$@" &> /dev/null &)
	exit 0
}

alias gm="git merge"
alias gf="git fetch"
alias gst="git status"
alias gdt="git dt"
alias ga="git add"
alias gb="git branch"
alias gco="git checkout"
alias gc="[ -e ./.git-commit-template ] && git commit -t ./.git-commit-template || git commit"
alias gp="git push"
alias gl="git pull"
alias glog="git log"
alias glogp='git log --pretty=format:"%h %s" --graph'

# alias ec="emacsclient -n"
## "Emacs edit"
# function ee() {
#	emacsclient -n "$@" > /dev/null 2>&1 || emacs "$@" > /dev/null 2>&1 &
# }

alias ls="ls -F --color=auto"
alias la="ls -A"
alias ll="ls -l"
alias l="ls -C"
alias sl="sl -e"

alias rmi="rm -i"
alias cpi="cp -i"
alias mvi="mv -i"

alias c="tail -n +1"

alias vvim="vim -n -u NONE " # 'Vanilla' vim - useful for editing VERY large files

alias open="xdg-open"

alias cb="xclip -selection clipboard"

alias tmux="tmux -2" # Force tmux to 256 colors

alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

#alias lock="xscreensaver-command -l"

alias nemo="nemo --no-desktop" # Stop the Desktop window from opening in i3
alias nautilus="nautilus --no-desktop" # See: above

# Beautify piped in XML and print it to stdout
function xmlbeautify() {
	python -c 'import sys;import xml.dom.minidom;s=sys.stdin.read().encode("UTF-8");print xml.dom.minidom.parseString(s).toprettyxml()' | sed '/^\s*$/d'
}

function sprungef() {
	file="$1"
	curloutput=$(cat "$1" | curl -sF "sprunge=<-" http://sprunge.us)
	result=$curloutput"?"${file##*.} # Append the file extension to the url to get syntax highlighting.
	echo $result
}

# ranger - change to last viewed directory on exit
function ranger-cd {
	tempfile="$(mktemp)"
	ranger --choosedir="$tempfile" "${@:-$(pwd)}"
	test -f "$tempfile" &&
		if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
			cd -- "$(cat "$tempfile")"
		fi
	rm -f -- "$tempfile"
}

# This binds Ctrl-O to ranger-cd:
bind '"\C-o":"ranger-cd\C-m"'

#function lock() {
#	xscreensaver-command -l > /dev/null 2>&1
#	if [ $? -eq 255 ]; then
#		xscreensaver &
#		xscreensaver-command -l
#	fi
#}

function parse_git_branch {
	ref=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) || return
	echo "($ref) "
}

function mkcd() {
	mkdir -p "$@" && cd $_
}

## Space checking
# Check how much space dotfiles are taking up
function dotspace() {
	for f in .*; do
		if ! [[ "$f" =~ \.\.?$ ]]; then
			du -hs "$f" | sort -h
		fi
	done
}

# Check how much space non-hidden files are taking up
function space() {
	for f in *; do
		du -hs "$f" | sort -h
	done
}

# If fzf is installed, use these fzf helper functions
if [ -f ~/.fzf.bash ]; then
	# fe [FUZZY PATTERN] - Open the selected file with the default editor
	#   - Bypass fuzzy finder if there's only one match (--select-1)
	#   - Exit if there's no match (--exit-0)
	function fe() {
		local file
		file=$(fzf-tmux --query="$1" --select-1 --exit-0)
		[ -n "$file" ] && ${EDITOR:-vim} "$file"
	}

	# Modified version where you can press
	#   - CTRL-O to open with `open` command,
	#   - CTRL-E or Enter key to open with the $EDITOR
	function fo() {
		local out file key
		out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
		key=$(head -1 <<< "$out")
		file=$(head -2 <<< "$out" | tail -1)
		if [ -n "$file" ]; then
			[ "$key" = ctrl-e ] && ${EDITOR:-vim} "$file" || open "$file"
		fi
	}

	function fh() { # fzf / includes hidden directories
		find . -name .git -prune -o $1 -print 2> /dev/null | sed 's@^..\(.*\)$@\1@' | fzf-tmux -x
	}

	function fd() {
		local dir
		dir=$(find ${1:-*} -path '*/\.*' -prune \
				   -o -type d -print 2> /dev/null | fzf-tmux +m) &&
			cd "$dir"
	}

fi



# Automatically add completion for all aliases to commands having completion functions
# Source: http://superuser.com/a/437508
function alias_completion {
	local namespace="alias_completion"

	# parse function based completion definitions, where capture group 2 => function and 3 => trigger
	local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
	# parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
	local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

	# create array of function completion triggers, keeping multi-word triggers together
	eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
	(( ${#completions[@]} == 0 )) && return 0

	# create temporary file for wrapper functions and completions
	rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
	local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

	local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"

	# read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
	local line; while read line; do
					eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
					local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

					# skip aliases to pipes, boolean control structures and other command lists
					# (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
					eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
					# avoid expanding wildcards
					read -a alias_arg_words <<< "$alias_args"

					# skip alias if there is no completion function triggered by the aliased command
					if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
						if [[ -n "$completion_loader" ]]; then
							# force loading of completions for the aliased command
							eval "$completion_loader $alias_cmd"
							# 124 means completion loader was successful
							[[ $? -eq 124 ]] || continue
							completions+=($alias_cmd)
						else
							continue
						fi
					fi
					local new_completion="$(complete -p "$alias_cmd")"

					# create a wrapper inserting the alias arguments if any
					if [[ -n $alias_args ]]; then
						local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
						# avoid recursive call loops by ignoring our own functions
						if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
							local compl_wrapper="_${namespace}::${alias_name}"
							echo "function $compl_wrapper {
						(( COMP_CWORD += ${#alias_arg_words[@]} ))
						COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
						(( COMP_POINT -= \${#COMP_LINE} ))
						COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
						(( COMP_POINT += \${#COMP_LINE} ))
						$compl_func
					}" >> "$tmp_file"
							new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
						fi
					fi

					# replace completion trigger by alias
					new_completion="${new_completion% *} $alias_name"
					echo "$new_completion" >> "$tmp_file"
				done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
	source "$tmp_file" && rm -f "$tmp_file"
}; alias_completion
