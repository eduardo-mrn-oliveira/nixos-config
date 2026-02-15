{
	user,
	pkgs,
	...
}: {
	environment.systemPackages = [
		pkgs.android-tools
	];

	users.extraGroups."adbusers".members = [user];
}
