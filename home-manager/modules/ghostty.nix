{config, ...}: {
	programs.ghostty = {
		enable = true;

		systemd.enable = true;

		settings = {
			window-padding-x = 16;
			window-padding-y = 16;
		};
	};

	# Manually satisfy the WantedBy=graphical-session.target directive
	# since the upstream module bypasses Home Manager's systemd evaluator
	xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source = "${config.programs.ghostty.package}/share/systemd/user/app-com.mitchellh.ghostty.service";
}
