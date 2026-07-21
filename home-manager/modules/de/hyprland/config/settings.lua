return {
	main_monitor = "eDP-1",
	-- main_monitor = "HDMI-A-1",
	monitor_modes = {
		["eDP-1"] = {
			"1368x768@60",
			"1600x900@60",
			"1920x1080@60"
		},
		["HDMI-A-1"] = {
			"1368x768@120",
			"1600x900@120",
			"1920x1080@120"
		},
	},
	worskpaces_per_monitor = 9,
	nixos_config_dir = "/home/vanisher/.nixos-config",
	mod = "SUPER"
}
