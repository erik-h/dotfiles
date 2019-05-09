function _git_status_each_do
	if [ (count $argv) -lt 1 ]
		echo "Usage: _git_status_each_do <command> [ arg ... ]" >&2
		return 1
	end

	git status --porcelain | awk '{print $2}' | sed "/.*.swp/d" | xargs $argv
end
