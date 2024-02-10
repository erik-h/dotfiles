# Usage: exe2iso <existing exe file> <new iso file>
function exe2iso --description "Extract an exe and plop its contents into an iso"
	set -l extracted_dir $argv[1]_extracted
	7z x -o$extracted_dir $argv[1]
	hdiutil makehybrid -iso -joliet -o $argv[2] $extracted_dir
	rm -rf $extracted_dir
end
