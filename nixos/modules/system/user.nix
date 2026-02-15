{
	pkgs,
	user,
	...
}: {
	users = {
		defaultUserShell = pkgs.bash;
		users.${user} = {
			isNormalUser = true;
			extraGroups = ["wheel" "networkmanager"];
			initialPassword = "nixos";
		};
	};
}
