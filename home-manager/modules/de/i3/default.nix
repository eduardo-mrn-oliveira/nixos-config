{pkgs, ...}: {
	imports = [
		./flameshot.nix
		./i3status.nix
		./rofi.nix
	];

	home.packages = with pkgs; [
		clipmenu
		redshift
	];

	xsession.windowManager.i3 = {
		enable = true;

		config = rec {
			modifier = "Mod4";
			terminal = "alacritty";
			menu = "rofi -show drun -display-drun \"\"";

			defaultWorkspace = "workspace number 1";

			workspaceLayout = "tabbed";
			window.titlebar = false;
			window.hideEdgeBorders = "smart";

			bars = [
				{
					statusCommand = "i3status";

					fonts = {
						names = ["monospace"];
						size = 16.0;
					};

					extraConfig = ''
						separator_symbol " : "
					'';
				}
			];

			keybindings = {
				# Apps
				"${modifier}+t" = "exec alacritty";
				"${modifier}+r" = "exec pkill rofi || rofi -show drun -display-drun \"\"";
				"${modifier}+e" = "exec nautilus";

				# Screenshots
				"${modifier}+p" = "exec flameshot gui";

				# Close window
				"${modifier}+q" = "kill";

				# Exit i3
				"${modifier}+Shift+e" = "exit";

				# Restart i3
				"${modifier}+Shift+r" = "restart";

				# Split
				"${modifier}+v" = "split v";
				"${modifier}+Shift+v" = "split h";

				# Fullscreen
				"${modifier}+f" = "fullscreen toggle";

				# Layouts
				"${modifier}+s" = "layout stacking";
				"${modifier}+w" = "layout tabbed";

				# Moving focus
				"${modifier}+Up" = "focus up";
				"${modifier}+Down" = "focus down";
				"${modifier}+Left" = "focus left";
				"${modifier}+Right" = "focus right";

				"${modifier}+z" = "focus left";
				"${modifier}+c" = "focus right";

				# Resizing windows
				"${modifier}+Ctrl+Left" = "resize shrink width 60 px";
				"${modifier}+Ctrl+Right" = "resize grow width 60 px";
				"${modifier}+Ctrl+Up" = "resize shrink height 60 px";
				"${modifier}+Ctrl+Down" = "resize grow height 60 px";

				# Switching workspaces
				"${modifier}+1" = "workspace number 1";
				"${modifier}+2" = "workspace number 2";
				"${modifier}+3" = "workspace number 3";
				"${modifier}+4" = "workspace number 4";
				"${modifier}+5" = "workspace number 5";
				"${modifier}+6" = "workspace number 6";
				"${modifier}+7" = "workspace number 7";
				"${modifier}+8" = "workspace number 8";
				"${modifier}+9" = "workspace number 9";
				"${modifier}+0" = "workspace number 10";

				"${modifier}+a" = "workspace prev";
				"${modifier}+d" = "workspace next";

				# Moving windows to workspaces
				"${modifier}+Shift+1" = "move container to workspace number 1";
				"${modifier}+Shift+2" = "move container to workspace number 2";
				"${modifier}+Shift+3" = "move container to workspace number 3";
				"${modifier}+Shift+4" = "move container to workspace number 4";
				"${modifier}+Shift+5" = "move container to workspace number 5";
				"${modifier}+Shift+6" = "move container to workspace number 6";
				"${modifier}+Shift+7" = "move container to workspace number 7";
				"${modifier}+Shift+8" = "move container to workspace number 8";
				"${modifier}+Shift+9" = "move container to workspace number 9";
				"${modifier}+Shift+0" = "move container to workspace number 10";

				"${modifier}+Shift+a" = "move container to workspace prev";
				"${modifier}+Shift+d" = "move container to workspace next";

				# Volume
				"XF86AudioRaiseVolume" = "exec --no-startup-id sh -c 'all-ctl volume +'";
				"XF86AudioLowerVolume" = "exec --no-startup-id sh -c 'all-ctl volume -'";
				"XF86AudioMute" = "exec --no-startup-id sh -c 'all-ctl volume toggle'";
				"XF86AudioMicMute" = "exec --no-startup-id sh -c 'all-ctl mic toggle'";

				# Brightness
				"XF86MonBrightnessUp" = "exec --no-startup-id sh -c 'all-ctl brightness +'";
				"${modifier}+period" = "exec --no-startup-id sh -c 'all-ctl brightness +'";
				"XF86MonBrightnessDown" = "exec --no-startup-id sh -c 'all-ctl brightness -'";
				"${modifier}+comma" = "exec --no-startup-id sh -c 'all-ctl brightness -'";

				# Audio Playback
				"XF86AudioNext" = "exec --no-startup-id sh -c 'all-ctl media next'";
				"XF86AudioPause" = "exec --no-startup-id sh -c 'all-ctl media play-pause'";
				"XF86AudioPlay" = "exec --no-startup-id sh -c 'all-ctl media play-pause'";
				"XF86AudioPrev" = "exec --no-startup-id sh -c 'all-ctl media previous'";

				# Redshift
				"${modifier}+m" = "exec --no-startup-id redshift -x";
				"${modifier}+n" = "exec --no-startup-id redshift -O 4500K";
			};
		};
	};
}
