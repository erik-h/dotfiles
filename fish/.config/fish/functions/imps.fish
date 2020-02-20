function imps -d 'Find files containing Java-style imports containing the give text.'
	if not command -v rg > /dev/null 2>&1
		echo "ERROR: ripgrep must be installed!" >&2
		return 1
	end
	if [ (count $argv) -lt 1 ]
		echo "Usage: imps <import search term>" >&2
		return 1
	end

	set -l term $argv[1]
	rg --smart-case "^import .*$term"
end
