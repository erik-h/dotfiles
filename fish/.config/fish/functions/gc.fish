function gc
	if [ -e ./.git-commit-template ]
		git commit -t ./.git-commit-template $argv
	else
		git commit $argv
	end
end
