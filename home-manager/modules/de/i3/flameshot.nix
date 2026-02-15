{user, ...}: {
	services.flameshot = {
		enable = true;

		settings = {
			General = {
				disabledTrayIcon = true;
				showStartupLaunchMessage = false;
				savePath = "/home/${user}/Images/Screenshots";
			};
		};
	};
}
