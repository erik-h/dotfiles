function ffgbd
	set -l branch (_fuzzy_git_branch $argv[1])
	if [ -z "$branch" ]
		return 1
	end

	git branch -D $branch
end
