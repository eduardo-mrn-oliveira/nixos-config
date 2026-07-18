{config, ...}: {
	services.tailscale = {
		enable = true;
		extraSetFlags = ["--netfilter-mode=nodivert"];
		extraDaemonFlags = ["--no-logs-no-support"];
	};

	systemd.services.tailscaled.serviceConfig.Environment = [
		"TS_DEBUG_FIREWALL_MODE=nftables"
	];

	networking.firewall = {
		allowedUDPPorts = [config.services.tailscale.port];
	};

	systemd.network.wait-online.enable = false;
	boot.initrd.systemd.network.wait-online.enable = false;
}
