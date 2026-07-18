{user, ...}: {
	programs.ydotool.enable = true;

	users.users.${user}.extraGroups = ["ydotool"];
}
