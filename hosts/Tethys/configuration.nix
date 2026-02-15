{
	pkgs,
	stateVersion,
	hostname,
	...
}: {
	imports = [
		./local-packages.nix

		../../nixos

		./modules/adb.nix
		./modules/keyboard.nix
		./modules/miniserve.nix
		./modules/mouse.nix
		./modules/nautilus.nix
		./modules/thunderbird.nix
		./modules/tlp.nix
		./modules/touchpad.nix
		./modules/virtualisation.nix

		./modules/cloudflare-warp.nix
		./modules/gnome-disks.nix

		./modules/local-dns.nix

		./modules/upower.nix
		./modules/laptop-lid.nix
		./modules/fonts.nix
		./modules/thumbnailers.nix
		./modules/external-backlight.nix
		./modules/steam-lan-transfer.nix
		./modules/tailscale.nix
		./modules/keyd.nix
		./modules/tty.nix
		./modules/intel.nix
		./modules/zero-tier.nix
		./modules/network-simulators.nix
	];

	environment.systemPackages = [pkgs.home-manager];

	networking.hostName = hostname;

	system.stateVersion = stateVersion;
}
