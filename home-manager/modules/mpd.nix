{
	services.mpd = {
		enable = true;

		extraConfig = ''
			audio_output {
				type "pipewire"
				name "PipeWire Sound Server"
			}
		'';
	};

	programs.rmpc = {
		enable = true;

		config = ''()'';
	};
}
