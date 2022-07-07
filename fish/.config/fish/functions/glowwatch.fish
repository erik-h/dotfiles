function glowwatch -d 'Watch a markdown file for changes, rendering it with `glow`'
	echo $argv | entr -c glow $argv
end
