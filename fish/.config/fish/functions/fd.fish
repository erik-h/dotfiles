function fd
	set fzf_tmux ~/.fzf/bin/fzf-tmux
	if not [ -e "$fzf_tmux" ]
		set fzf_tmux /opt/homebrew/bin/fzf-tmux
		if not [ -e "$fzf_tmux" ]
			echo "'fzf-tmux' script is missing! It should be located at: $fzf_tmux"
			return 1
		end
	end

	set root_dir $argv[1]
	test -z "$root_dir"; and set root_dir *

	set dir (find $root_dir -path '*/\.*' -prune \
				   -o -type d -print 2> /dev/null | eval $fzf_tmux +m)
	if [ -n "$dir" ]
		cd $dir
	end
end
