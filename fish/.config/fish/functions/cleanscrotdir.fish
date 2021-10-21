function cleanscrotdir -d 'Delete all corrupted screenshots'
	pushd ~/Pictures/screenshots
	for f in *.png
		if ! identify $f &> /dev/null
			rm $f
		end
	end
	popd
end
