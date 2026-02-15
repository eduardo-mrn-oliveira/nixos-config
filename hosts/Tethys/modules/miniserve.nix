{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		miniserve
	];

	networking.firewall.allowedTCPPorts = [8080];
}
