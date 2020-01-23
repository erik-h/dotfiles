function up
	if [ (count $argv) -ne 1 ]; or string match --quiet --regex '\D' $argv[1]; or [ $argv[1] -lt 1 ]
		echo "Usage: up <number of directories to `cd` 'up'>"
		return 1
	end

	set -l upstring ""
	for i in (seq 1 $argv[1])
		set upstring "../$upstring"
	end

	cd $upstring
end
