function adbwake
	# Send the "show me the unlock screen" key event (i.e. wake up the phone)
	adb shell input keyevent 82
end
