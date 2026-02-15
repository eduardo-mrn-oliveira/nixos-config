{
	programs.i3status = {
		enable = true;

		enableDefault = false;

		general = {
			colors = true;
			interval = 5;
		};

		modules = {
			"time" = {
				position = 4;
				settings = {
					format = "%Y-%m-%d %H:%M";
				};
			};

			"battery all" = {
				position = 3;
				settings = {
					last_full_capacity = true;
					format = "%status %percentage";
				};
			};

			"volume master" = {
				position = 2;
				settings = {
					format = "VOL %volume";
					device = "default";
				};
			};

			"wireless _first_" = {
				position = 1;
				settings = {
					format_up = "WIFI %quality @ %essid";
					format_down = "WIFI down";
				};
			};
		};
	};
}
