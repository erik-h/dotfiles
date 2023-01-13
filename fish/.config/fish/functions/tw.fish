function tw --description 'Watch a Twitch stream using streamlink with chat in a Firefox popout window'
	streamlink -p mpv -a "--cache=yes --demuxer-max-bytes=750k --profile=low-latency" --twitch-disable-ads --twitch-low-latency --hls-live-edge 2 https://www.twitch.tv/$argv best &> /dev/null & disown
	firefox --new-window "https://www.twitch.tv/popout/$argv/chat?popout="
end
