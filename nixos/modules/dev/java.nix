{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		openjdk21
	];
}
