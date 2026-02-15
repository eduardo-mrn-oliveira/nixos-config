{
	programs.atuin = {
		enable = true;
		daemon.enable = true;

		enableBashIntegration = true;

		settings = {
			inline_height = 0;
			filter_mode_shell_up_key_binding = "session";
			enter_accept = true;
		};
	};
}
