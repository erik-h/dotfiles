function fb
	if git rev-parse HEAD >/dev/null 2>&1
		set branch (bash -c "source $XDG_CONFIG_HOME/fzf/fzf-git.sh && _fzf_git_branches")
		git switch $branch
	end
end
