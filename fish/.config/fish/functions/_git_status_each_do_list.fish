function _git_status_each_do_list
	if [ (count $argv) -lt 1 ]
		echo "Usage: _git_status_each_do_list <command> [ arg ... ]"
		return 1
	end
	git status --porcelain | awk '{print $2}' | xargs $argv | cut -d ':' -f1 | uniq
end
