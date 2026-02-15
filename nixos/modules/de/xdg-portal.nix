{pkgs, ...}: {
	xdg.portal = {
		enable = true;

		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
		];

		config = {
			common = {
				default = ["gtk"];
				"org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
			};

			hyprland = {
				default = ["hyprland"];
				"org.freedesktop.impl.portal.FileChooser" = ["gtk"];
			};
		};
	};
}
