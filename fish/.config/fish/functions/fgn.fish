function fgn
	# If we don't have the right number of arguments (as of writing this
	# comment...) then let `git nuke` spit out a usage message.
	# We need at least one argument (the remote; we don't fuzzy match it
	# because you _probably_ don't have more than two, reasonably shortly named
	# remotes).
	if [ (count $argv) -lt 1 ]
		git nuke
		return 1
	end

	set -l remote $argv[1]
	set -l branch (_fuzzy_git_branch $argv[2])
	if [ -z "$branch" ]
		return 1
	end

	git nuke $remote $branch
end
