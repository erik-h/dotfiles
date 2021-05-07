function gwa --description 'Shortcut for quickly using `git worktree add`'
	if test (count $argv) -lt 1
		echo "Branch must be provided as an argument." >&2
		return 1
	end

	git worktree add TMP $argv[1]
end
