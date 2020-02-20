function pysmtp --description 'Run a local SMTP server for debugging email notifications.'
	if [ -n "$argv[1]" ]
		set port $argv[1]
	else
		set port 1025
	end
	echo "Running SMTP server on localhost:$port ..." >&2
	python -m smtpd -n -c DebuggingServer localhost:$port
end
