{
	programs.alacritty = {
		enable = true;

		settings = {
			window.padding = {
				x = 16;
				y = 16;
			};

			env.TERM = "xterm-256color";

			mouse.bindings = [
				{
					mouse = "Right";
					action = "Copy";
				}
				{
					mouse = "Right";
					mods = "Control";
					action = "Paste";
				}
			];
		};
	};
}
