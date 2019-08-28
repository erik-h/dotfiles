function ytmp3 -d 'Download the given YouTube video as the highest possible quality MP3'
	youtube-dl -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 $argv
end
