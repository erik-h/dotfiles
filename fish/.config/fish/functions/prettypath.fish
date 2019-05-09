function prettypath
	echo $PATH | tr ' ' '\n' | sort | uniq
end
