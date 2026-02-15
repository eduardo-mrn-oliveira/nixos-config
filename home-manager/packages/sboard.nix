{pkgs}:
pkgs.writeShellScriptBin "sboard" ''
	DIR="''${1:-$HOME/Musics/Soundboard}"

	FIND="${pkgs.findutils}/bin/find"
	FZF="${pkgs.fzf}/bin/fzf"
	MPV="${pkgs.mpv}/bin/mpv"
	PKILL="${pkgs.procps}/bin/pkill"

	SINK="pipewire/Virtual-Sink-Discord"

	if [ ! -d "$DIR" ]; then
	  echo "Directory not found: $DIR"
	  exit 1
	fi

	cd "$DIR" || exit 1

	$FIND . -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.flac" -o -iname "*.ogg" -o -iname "*.webm" \) -printf "%P\n" | \
	$FZF --prompt="Soundboard > " \
		--height=100% \
		--layout=reverse \
		--header="Enter: Play | Ctrl-Space: Stop All" \
		--bind "enter:execute-silent($MPV --audio-device='$SINK' --no-video --title='sboard-audio' {} &)+clear-selection" \
		--bind "ctrl-space:execute-silent($PKILL -f \"^$MPV.*sboard-audio\")"
''
