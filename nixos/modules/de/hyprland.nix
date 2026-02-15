{
	inputs,
	system,
	config,
	pkgs,
	...
}: let
	hyprland =
		inputs.hyprland.packages.${system}.hyprland;

	# Overrides the "hyprland-uwsm" session
	uwsmSession =
		pkgs.writeTextFile {
			name = "hyprland-uwsm-session";
			destination = "/share/wayland-sessions/hyprland-uwsm.desktop";
			derivationArgs = {
				passthru.providedSessions = ["hyprland-uwsm"];
			};
			text = ''
				[Desktop Entry]
				Name=Hyprland (UWSM)
				Comment=Hyprland managed by UWSM
				Exec=${config.programs.uwsm.package}/bin/uwsm start -F -- ${config.programs.hyprland.package}/bin/start-hyprland
				Type=Application
				DesktopNames=Hyprland
			'';
		};
in {
	programs.hyprland = {
		enable = true;
		withUWSM = true;
		xwayland.enable = true;

		package = hyprland;
	};

	services.displayManager.sessionPackages = [
		uwsmSession
	];
}
