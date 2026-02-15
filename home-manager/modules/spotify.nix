{rolling, ...}: {
	# programs.spotify-player = {
	# 	enable = true;

	# 	package =
	# 		pkgs.spotify-player.override {
	# 			withAudioBackend = "pulseaudio";
	# 		};

	# 	settings = {
	# 		device = {
	# 			name = "Tethys";
	# 			device_type = "computer";
	# 			audio_backend = "pulseaudio";
	# 		};

	# 		enable_streaming = "Always";

	# 		default_device = "Tethys";
	# 	};
	# };

	programs.ncspot = {
		enable = true;

		package = rolling.ncspot;
	};

	services.spotifyd = {
		enable = true;

		settings = {
			global = {
				device_name = "Tethys";
				device_type = "computer";

				backend = "pulseaudio";
				audio_format = "F32";
				bitrate = 320;

				initial_volume = 90;
				volume_normalisation = true;

				use_mpris = true;
				dbus_type = "session";

				disable_discovery = true;

				autoplay = false;

				# on_song_change_hook = "";
			};
		};
	};
}
