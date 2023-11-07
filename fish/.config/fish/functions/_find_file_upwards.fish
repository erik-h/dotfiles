function _find_file_upwards --description 'Recursively search upwards for the given filename starting at the given directory'
	set -l filename $argv[1]
	set -l current_dir $argv[2]

	if test "$current_dir" = "/"
		return
	end

	set -l path $current_dir/$filename
	if test -f $path
		echo $path
	else
		_find_file_upwards $filename (dirname $current_dir)
	end
end
