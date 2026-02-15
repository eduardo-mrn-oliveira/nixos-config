{lib, ...}: {
	programs.waybar = {
		enable = true;

		style =
			lib.mkAfter ''
				#network,
				#pulseaudio,
				#battery,
				#tray,
				#clock {
					margin-left: 12px;
				}
			'';

		settings = {
			mainBar = {
				layer = "top";
				position = "bottom";

				height = 30;

				# Sync issues with hyprtasking
				# modules-left = ["hyprland/window"];
				modules-left = ["hyprland/workspaces"];

				modules-right = ["network" "pulseaudio" "battery" "tray" "clock"];

				"hyprland/window" = {
					"format" = "{title}";
					"max-length" = 45;
					"separate-outputs" = true;
				};

				"hyprland/workspaces" = {
					disable-scroll = true;
					show-special = true;
					special-visible-only = true;
					all-outputs = false;
					format = "{icon}";
					format-icons = {
						"1" = "1";
						"2" = "2";
						"3" = "3";
						"4" = "4";
						"5" = "5";
						"6" = "6";
						"7" = "7";
						"8" = "8";
						"9" = "9";
						"0" = "10";
					};
				};

				"network" = {
					interface = "wlp2s0";
					format = "{ifname}";
					format-wifi = "  {essid} ({signalStrength}%)";
					format-ethernet = "󰊗  {ipaddr}/{cidr}";
					format-disconnected = "";
					tooltip-format = "{ifname} via {essid}";
					tooltip-format-ethernet = "{ifname}";
				};

				"pulseaudio" = {
					format = "{icon} {volume}%";
					format-bluetooth = "{icon} {volume}% ";
					format-muted = "";
					format-icons = {
						"headphones" = "";
						"handsfree" = "";
						"headset" = "";
						"phone" = "";
						"portable" = "";
						"car" = "";
						"default" = ["" ""];
					};
					on-click = "pavucontrol";
				};

				"battery" = {
					states = {
						warning = 30;
						critical = 1;
					};
					format = "{icon} {capacity}%";
					format-charging = " {capacity}%";
					format-alt = "{time} {icon}";
					format-icons = ["" "" "" "" ""];
				};

				"tray" = {
					"icon-size" = 24;
					"spacing" = 10;
				};

				"clock" = {
					format = "{:%Y-%m-%d %H:%M}";
					format-alt = "{:%A, %B %d at %R}";
					tooltip = false;
				};
			};
		};
	};
}
