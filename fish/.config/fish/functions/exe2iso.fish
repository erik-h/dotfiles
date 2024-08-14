# Usage: exe2iso <existing exe file> <new iso file>
function exe2iso --description "Extract an exe and plop its contents into an iso"
	if test (count $argv) -lt 2
		echo "Usage:" (status function) "<existing exe file> <new iso file>" >&2
		return 1
	end
	set -l extracted_dir $argv[1]_extracted
	7z x -o$extracted_dir $argv[1]
	hdiutil makehybrid -iso -joliet -o $argv[2] $extracted_dir
	rm -rf $extracted_dir
end
