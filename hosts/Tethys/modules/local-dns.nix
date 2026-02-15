{
	networking.search = ["cuttlefish-notothen.ts.net"];
	networking.nameservers = ["127.0.0.1"];

	services.dnsmasq = {
		enable = true;
		settings = {
			addn-hosts = "/etc/local-hosts";

			server = [
				"/ts.net/100.100.100.100"
				"9.9.9.9"
			];

			no-resolv = true;

			interface = "lo";
			bind-interfaces = true;
		};
	};

	services.tailscale.extraSetFlags = ["--accept-dns=false"];
}
