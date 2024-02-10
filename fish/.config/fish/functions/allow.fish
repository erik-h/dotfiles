function allow --description 'Disable macOS quarantine for the given executable'
	xattr -d com.apple.quarantine $argv[1]
end
