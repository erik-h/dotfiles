function rgg
	if not command -v rg > /dev/null 2>&1
		echo "ERROR: ripgrep must be installed!" >&2
		return 1
	end
	if [ (count $argv) -lt 1 ]
		echo "Usage: rgg <regex> [path to search]" >&2
		return 1
	end

	set regex $argv[1]
	set path ""
	if [ (count $argv) -gt 1 ]
		set path $argv[2]
	end
	# Default to searching recursively down from the current working directory,
	# as `ag` does.
	if [ -z "$path" ]
		set path "."
	end

	rg --files $path | rg $regex
end
