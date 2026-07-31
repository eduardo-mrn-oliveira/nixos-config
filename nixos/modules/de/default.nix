{pkgs, ...}: {
	imports = [
		./hyprland.nix
		./xdg-portal.nix

		./greeter # TODO: Separate configurable modules from Nix config files
	];

	yVanisher.greeter = {
		enable = true;

		settings = {
			staticSource = "/etc/yGreeter/wallpapers/phrolova-wind.png";
			staticFillMode = "Stretch";

			animatedSource = "/etc/yGreeter/wallpapers/phrolova-wind.mp4";
			animatedFillMode = "Stretch";

			startEnabled = true;
			startAnimated = false;

			isMuted = true;
			volume = 10;
		};

		terminalSessions = [
			{
				name = "Bash (Rescue)";
				exec = "${pkgs.bashInteractive}/bin/bash --noprofile --norc";
			}
		];
	};
}
