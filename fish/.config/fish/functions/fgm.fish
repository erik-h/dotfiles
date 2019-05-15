function fgm
	set -l branch (_fuzzy_git_branch $argv[1])
	if [ -z "$branch" ]
		return 1
	end

	git merge $branch
end
