function latestcast
	set -l cast_dir "$HOME/Videos/screencasts"
	set -l latest (find $cast_dir -print0 | xargs -r -0 ls -1 -t 2>/dev/null | head -1)
	mpv $latest
end
