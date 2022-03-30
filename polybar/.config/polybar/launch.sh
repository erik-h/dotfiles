#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar


# Plop a bunch of dashes into the log file to denote that we've restarted polybar
{ printf -- '-%.0s' {1..80}; echo; } | tee -a /tmp/polybar.log

i=0
for m in $(polybar --list-monitors | cut -d':' -f1 | tac); do
	if [[ $i -eq 0 ]]; then
		export TRAY_POSITION=right
	else
		export TRAY_POSITION=none
	fi
	MONITOR="$m" polybar --reload 2>&1 | tee -a /tmp/polybar.log & disown
	((i++))
done
