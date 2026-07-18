{
	inputs,
	system,
	config,
	pkgs,
	...
}: let
	hyprland =
		inputs.hyprland.packages.${system}.hyprland;
in {
	programs.uwsm = {
		enable = true;
	};

	programs.hyprland = {
		enable = true;
		withUWSM = true;
		xwayland.enable = true;

		package = hyprland;
	};

	xdg.portal = {
		enable = true;

		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
		];

		config = {
			hyprland = {
				default = ["hyprland"];
				"org.freedesktop.impl.portal.FileChooser" = ["gtk"];
			};
		};
	};

	yVanisher.greeter.graphicalSessions = [
		{
			name = "Hyprland";
			exec = "${config.programs.uwsm.package}/bin/uwsm start -- ${config.programs.hyprland.package}/bin/start-hyprland";
		}
	];
}
