{
	nixpkgs.config.allowUnfree = true;

	imports = [
		./gamemode.nix
		./proton-ge.nix
		./steam.nix
	];

	hardware.graphics.enable = true;
	hardware.graphics.enable32Bit = true;
}
