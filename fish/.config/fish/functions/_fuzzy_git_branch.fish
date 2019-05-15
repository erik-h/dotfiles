function _fuzzy_git_branch
	git branch --all | sed -e "s/^[ \t]*//" -e "s/^\* //" -e 's/^remotes\///' -e '/ -> /d' | fzf --query=$argv[1]
end
