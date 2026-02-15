{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		gcc
		gdb

		cmake
		gnumake

		ninja
	];
}
