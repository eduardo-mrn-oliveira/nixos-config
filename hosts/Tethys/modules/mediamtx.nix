{
	services.mediamtx = {
		enable = true;

		settings = {
			webrtcAddress = ":8889";
			webrtcLocalUDPAddress = ":8189";
			rtspAddress = ":8554";

			paths = {
				all = {};
			};
		};
	};

	networking.firewall = {
		interfaces = {
			zerotier0 = {
				allowedTCPPorts = [8554 8889];
				allowedUDPPorts = [8189];
			};

			tailscale0 = {
				allowedTCPPorts = [8554 8889];
				allowedUDPPorts = [8189];
			};
		};
	};
}
