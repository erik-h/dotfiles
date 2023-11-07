function gradle
	set -l gradlew (_find_file_upwards "gradlew" $PWD)

	if test -z "$gradlew"
		echo "Could not find gradlew searching from $PWD to /"
		return 1
	end

	echo "Using gradlew: $gradlew"
	eval $gradlew $argv
end
