{
	inputs,
	hostname,
	root,
	user,
	lib,
	...
}: {
	environment.etc.".nixos-config".source = inputs.self;

	image.baseName = lib.mkForce hostname;

	boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

	# isoImage.squashfsCompression = "lz4";

	isoImage.makeEfiBootable = true;

	systemd.services.init-nixos-config = {
		description = "Initialize configuration directory";
		wantedBy = ["multi-user.target"];
		unitConfig.ConditionPathExists = "!${root}";
		serviceConfig = {
			Type = "oneshot";
			User = "root";
		};
		script = ''
			cp -r --no-preserve=mode /etc/.nixos-config ${root}
			chown -R ${user}:users ${root}
		'';
	};
}
