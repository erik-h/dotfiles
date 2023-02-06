function unblob --description 'Extract (almost) anything!'
	docker run \
		--rm \
		--pull always \
		-v $PWD:/data/output \
		-v $PWD:/data/input \
		ghcr.io/onekey-sec/unblob:latest $argv
end
