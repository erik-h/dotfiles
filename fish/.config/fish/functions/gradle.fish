function gradle
	set -l gradlew (_find_file_upwards "gradlew" $PWD)

	if test -z "$gradlew"
		echo "Could not find gradlew searching from $PWD to /"
		return 1
	end

	if isatty stdin
		set -l pipe_input ""
	else
		read -l pipe_input
	end

	echo "Using gradlew: $gradlew"
	eval "echo $pipe_input | $gradlew $argv"
end
