{
	services.sunshine = {
		enable = true;
		settings = {
			output_name = "REMOTE";
			system_tray = "disabled";
			stream_audio = "disabled";
			controller = "disabled";
			mouse = "disabled";
			keyboard = "disabled";
		};
	};

	networking.firewall = {
		interfaces."tailscale0" = {
			allowedTCPPorts = [47984 47989 48010];
			allowedUDPPortRanges = [
				{
					from = 47998;
					to = 48000;
				}
				{
					from = 8000;
					to = 8010;
				}
			];
		};
	};
}
