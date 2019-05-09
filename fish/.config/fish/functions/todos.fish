function todos
	# TODO: should ensure `rg` is installed, otherwise use `ag`, otherwise `grep`
	set search_cmd "rg"
	set search_cmd_args "TODO|FIXME|DEBUG"
	set arg $argv[1]; or set arg ""

	if [ "$arg" = "-f" ]; or [ "$arg" = "--files" ]
		_git_status_each_do_list $search_cmd -H --no-heading $search_cmd_args
	else if [ "$arg" = "-a" ]; or [ "$arg" = "--all" ]
		eval $search_cmd '"$search_cmd_args"'
	else
		_git_status_each_do $search_cmd $search_cmd_args
	end
end
