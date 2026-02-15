{pkgs}:
pkgs.writeShellScriptBin "all-ctl" ''
	#!/usr/bin/env bash

	# Usage: notify <replace_id> <icon> <title> <content> <optional_timeout>
	notify() {
		dunstify -r "$1" -i "$2" "$3" "$4" ''${5:+-t "$5"}
	}

	case $1 in
		volume)
			# Action
			if [ "$2" = "toggle" ]; then
				wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
			else
				wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%"$2"
			fi

			# Get Status
			is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "yes" || echo "no")
			if [ "$is_muted" = "yes" ]; then
				notify 2593 "audio-volume-muted" "Volume" "Muted" 2000
			else
				volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | cut -d'.' -f1)
				notify 2593 "audio-volume-high" "Volume" "$volume%" 2000
			fi
			;;

		mic)
			# Action
			wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
			# Get Status
			is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED" && echo "yes" || echo "no")
			if [ "$is_muted" = "yes" ]; then
				notify 2594 "microphone-sensitivity-muted" "Microphone" "Muted" 2000
			else
				notify 2594 "microphone-sensitivity-high" "Microphone" "On" 2000
			fi
			;;

		brightness)
			# Action
			brightnessctl set 10%"$2"
			# Get Status
			brightness_p=$(brightnessctl -m | awk -F, '{print int($4)}')
			notify 9921 "display-brightness" "Brightness" "$brightness_p%" 2000
			;;

		media)
			# Action
			playerctl "$2"
			# Get Status (wait a bit for playerctl to update)
			sleep 0.1
			status=$(playerctl status)
			if [ "$status" = "Playing" ]; then
				track_info=$(playerctl metadata --format "{{ artist }} - {{ title }}")
				notify 6969 "media-playback-start" "$track_info" "Playing" 4000
			elif [ "$status" = "Paused" ]; then
				notify 6969 "media-playback-pause" "Player" "Paused" 4000
			fi
			;;
	esac
''
