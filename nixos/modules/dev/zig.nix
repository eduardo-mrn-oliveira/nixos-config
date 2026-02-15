{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		zig_0_15
	];
}
