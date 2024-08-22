function fe
	set fzf_tmux ~/.fzf/bin/fzf-tmux
	if not [ -e "$fzf_tmux" ]
		set fzf_tmux /opt/homebrew/bin/fzf-tmux
		if not [ -e "$fzf_tmux" ]
			echo "'fzf-tmux' script is missing! It should be located at: $fzf_tmux"
			return 1
		end
	end

	if git rev-parse HEAD >/dev/null 2>&1
		set file (bash -c "source $XDG_CONFIG_HOME/fzf/fzf-git.sh && _fzf_git_files")
	else
		# TODO: use the fancier pop-up fzf window that's being used for the
		# above _fzf_git_files call for this "search for file while not in
		# a git repo" case too.
		set file (eval $fzf_tmux --query=$argv[1] --select-1 --exit-0)
	end

	set editor $EDITOR
	test -z "$editor"; and set editor "vim"

	if [ -n "$file" ]
		eval $editor $file
		printf "$file\n" >&2 
	end
end
