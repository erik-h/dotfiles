function docker-remove-all-containers --description 'Remove all stopped Docker containers.'
	set -l containers (docker ps -a -q)
	if [ -n "$containers" ]
		docker rm $containers
	else
		echo "There are no stopped containers to remove!" >&2
	end
end
