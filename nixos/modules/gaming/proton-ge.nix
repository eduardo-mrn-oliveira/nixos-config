{pkgs, ...}: {
	programs.steam.extraCompatPackages = with pkgs; [
		proton-ge-bin
	];
}
