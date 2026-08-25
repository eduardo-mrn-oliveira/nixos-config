{pkgs}:
pkgs.writeShellScriptBin "all-ctl" ''
	#!/usr/bin/env bash

	notify() {
		${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:"$1" -h byte:transient:1 -n "$2" "$3" "$4" ''${5:+-t "$5"}
	}

	case $1 in
		volume)
			if [ "$2" = "toggle" ]; then
				${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
			else
				${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%"$2"
			fi

			is_muted=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${pkgs.gnugrep}/bin/grep -q "MUTED" && echo "yes" || echo "no")
			if [ "$is_muted" = "yes" ]; then
				notify "sys-vol" "audio-volume-muted" "Volume" "Muted" 2000
			else
				volume=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${pkgs.gawk}/bin/awk '{print $2 * 100}' | ${pkgs.coreutils}/bin/cut -d'.' -f1)
				notify "sys-vol" "audio-volume-high" "Volume" "$volume%" 2000
			fi
			;;

		mic)
			${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

			is_muted=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | ${pkgs.gnugrep}/bin/grep -q "MUTED" && echo "yes" || echo "no")
			if [ "$is_muted" = "yes" ]; then
				notify "sys-mic" "microphone-sensitivity-muted" "Microphone" "Muted" 2000
			else
				notify "sys-mic" "microphone-sensitivity-high" "Microphone" "On" 2000
			fi
			;;

		brightness)
			${pkgs.brightnessctl}/bin/brightnessctl set 10%"$2"

			brightness_p=$(${pkgs.brightnessctl}/bin/brightnessctl -m | ${pkgs.gawk}/bin/awk -F, '{print int($4)}')
			notify "sys-bright" "display-brightness" "Brightness" "$brightness_p%" 2000
			;;

		media)
			${pkgs.playerctl}/bin/playerctl "$2"

			${pkgs.coreutils}/bin/sleep 0.1
			status=$(${pkgs.playerctl}/bin/playerctl status)

			if [ "$status" = "Playing" ]; then
				track_info=$(${pkgs.playerctl}/bin/playerctl metadata --format "{{ artist }} - {{ title }}")
				notify "sys-media" "media-playback-start" "$track_info" "Playing" 4000
			elif [ "$status" = "Paused" ]; then
				notify "sys-media" "media-playback-pause" "Player" "Paused" 4000
			fi
			;;
	esac
''
