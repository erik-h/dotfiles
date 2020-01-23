function di --description 'Run `docker images` with a filter applied to hide dangling (i.e. name-less) images.'
	docker images --filter dangling=false $argv
end
