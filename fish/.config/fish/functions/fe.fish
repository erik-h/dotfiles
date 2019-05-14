function fe
	set fzf_tmux ~/.fzf/bin/fzf-tmux
	if not [ -e "$fzf_tmux" ]
		echo "'fzf-tmux' script is missing! It should be located at: $fzf_tmux"
		return 1
	end

	set file (eval $fzf_tmux --query=$argv[1] --select-1 --exit-0)

	set editor $EDITOR
	test -z "$editor"; and set editor "vim"

	if [ -n "$file" ]
		eval $editor $file
		printf "$file\n" >&2 
	end
end
