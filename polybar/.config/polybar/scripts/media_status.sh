#!/usr/bin/env bash

# playerctl metadata | grep ':title' | tr -s ' ' | cut -d' ' -f3-

MEDIA_STATUS_MAX_LEN=40

metadata="$(playerctl metadata 2>&1)"
if [[ "$metadata" == "No players found" ]]; then
	# We've got no media playing.
	# Spit out an empty line so that any old media status is cleared out.
	echo ""
	exit 0
fi

title="$(grep ':title' <<< "$metadata" | tr -s ' ' | cut -d' ' -f3-)"
artist="$(grep ':artist' <<< "$metadata" | tr -s ' ' | cut -d' ' -f3-)"
player_status="$(playerctl status)"
if [[ "$player_status" == "Playing" ]]; then
	media_msg=" $title - $artist"
else
	media_msg=" $title - $artist"
fi
if [[ $(wc -c <<< "$media_msg") -gt $MEDIA_STATUS_MAX_LEN ]]; then
	echo "${media_msg:0:$MEDIA_STATUS_MAX_LEN}..."
else
	echo "$media_msg"
fi
