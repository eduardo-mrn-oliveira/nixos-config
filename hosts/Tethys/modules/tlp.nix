{user, ...}: {
	services.tlp = {
		enable = true;

		settings = {
			# AC

			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_AC = "performance";

			CPU_MIN_PERF_ON_AC = 0;
			CPU_MAX_PERF_ON_AC = 100;

			# BATTERY

			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

			CPU_MIN_PERF_ON_BAT = 0;
			CPU_MAX_PERF_ON_BAT = 50;

			# CHARGING

			START_CHARGE_THRESH_BAT0 = 0;
			STOP_CHARGE_THRESH_BAT0 = 1;
		};
	};

	security.sudo.extraRules = [
		{
			users = [user];
			commands = [
				{
					command = "/run/current-system/sw/bin/tlp";
					options = ["NOPASSWD"];
				}
			];
		}
	];
}
