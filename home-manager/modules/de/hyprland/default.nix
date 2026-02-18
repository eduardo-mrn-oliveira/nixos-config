{
	inputs,
	system,
	pkgs,
	user,
	lib,
	...
}: let
	hyprtasking =
		inputs.hyprtasking.packages.${system}.hyprtasking;
in {
	imports = [
		# ./hyprpaper.nix

		# ./waybar.nix
		./quickshell

		./clipboard.nix

		./wofi.nix
	];

	home.packages = with pkgs; [
		hyprsunset
		hyprshot
		wayvnc
	];

	home.sessionVariables = {
		"HYPRSHOT_DIR" = "/home/${user}/Images/Screenshots";
	};

	wayland.windowManager.hyprland = {
		enable = true;
		systemd.enable = true;

		package = null;
		portalPackage = null;

		plugins = [
			hyprtasking
		];

		settings = {
			monitor = [
				"eDP-1,1368x768@60,0x0,1"
				"HDMI-A-1,preferred,auto-right,1"
				# "REMOTE,2400x1080@60,-516x-1080,1"
				"REMOTE,1368x616@60,0x-616,1"
			];

			workspace = [
				"1, monitor:eDP-1, default:true"
				"2, monitor:eDP-1, default:true"
				"3, monitor:eDP-1, default:true"
				"4, monitor:eDP-1, default:true"
				"5, monitor:eDP-1, default:true"
				"6, monitor:eDP-1, default:true"
				"7, monitor:eDP-1, default:true"
				"8, monitor:eDP-1, default:true"
				"9, monitor:eDP-1, default:true"
				"10, monitor:REMOTE, default:true"
			];

			plugin = {
				hyprtasking = {
					gap_size = 8;
					border_size = 2;

					bg_color = "0x00000000";

					select_button = "0x110";
					drag_button = "0x111";
				};
			};

			misc = {
				focus_on_activate = true;

				disable_hyprland_logo = true;
				force_default_wallpaper = 0;
				background_color = lib.mkForce "rgb(000000)";
			};

			"$mainMod" = "SUPER";
			"$mod" = "SUPER";

			"$terminal" = "alacritty";
			"$fileManager" = "nautilus --new-window";
			"$menu" = "pkill wofi || wofi --show drun --prompt \"\"";

			general = {
				gaps_in = 4;
				gaps_out = 0;
			};

			animations = {
				enabled = false;
			};

			windowrule = [
				"match:class .*, group set"
				"match:workspace w[g1], border_size 0"
				"match:workspace w[t1], border_size 0"
			];

			"group:groupbar" = {
				font_size = 16;
				height = 20;
			};

			input = {
				kb_layout = "br";
				kb_variant = "abnt2";

				touchpad = {
					natural_scroll = true;
				};

				follow_mouse = 2;
			};

			exec-once = [
				"uwsm finalize"
				"hyprsunset"
				"hyprctl output create headless REMOTE"
			];

			env = [
				# Hint Electron apps to use Wayland
				"NIXOS_OZONE_WL,1"
				"XDG_SESSION_DESKTOP,Hyprland"
				"XDG_CURRENT_DESKTOP,Hyprland"
				"XDG_SESSION_TYPE,wayland"
				"QT_QPA_PLATFORM,wayland"
				"_JAVA_AWT_WM_NONREPARENTING,1"
			];

			bind = let
				soundboardBinds = let
					soundboard = n: let
						idx = toString n;
					in [
						"$mod, F${idx}, exec, mpv --audio-device='pipewire/Virtual-Sink-Discord' --no-video --title='hyprland-soundboard-${idx}' ~/Musics/Hyprland/${idx}"
						"$mod SHIFT, F${idx}, exec, pkill -f hyprland-soundboard-${idx}"
					];
				in
					builtins.concatLists (map soundboard (builtins.genList (i: i + 1) 12));
			in
				[
					# Toogle keybinds
					"$mod, Insert, submap, clean"

					# Apps
					"$mod, T, exec, $terminal"
					"$mod, R, exec, $menu"
					"$mod, E, exec, $fileManager"

					# Workspaces
					", Escape, hyprtasking:if_active, hyprtasking:toggle cursor"
					"$mod, Tab, hyprtasking:toggle, cursor"
					"CTRL, Tab, hyprtasking:toggle, cursor"
					"$mod, KP_Enter, hyprtasking:toggle, cursor"

					# Switch to last window
					"ALT, Tab, focuscurrentorlast"

					# Poweroff
					"$mod SHIFT, End, exec, poweroff"

					# Reboot
					"$mod SHIFT, Delete, exec, reboot"

					# Screenshots
					"$mod, P, exec, hyprshot -zm region"
					"$mod ALT, P, exec, hyprshot -zm region --cursor"

					# Close window
					"$mod, Q, killactive"

					# Fix Hyprshot
					"$mod SHIFT, P, exec, pkill -9 hyprpicker"

					# Exit Hyprland
					"$mod SHIFT, E, exit"

					# Hide/unhide taskbar
					"$mod, W, exec, qs ipc call taskbar toggle"

					# Wallpaper
					"$mod SHIFT, space, exec, qs ipc call wallpaper toggle"
					"$mod, space, exec, qs ipc call wallpaper toggleAnimation"
					"$mod ALT, space, exec, qs ipc call wallpaper playPause"

					# Restart Quickshell
					"$mod SHIFT, W, exec, systemctl --user restart quickshell"

					# Fullscreen
					"$mod, F, fullscreen"

					# Moving focus
					# "$mod, up, movefocus, u"
					# "$mod, down, movefocus, d"

					# Toggle floating
					"$mod, V, togglefloating"

					# Moving windows
					"$mod SHIFT, left,  swapwindow, l"
					"$mod SHIFT, right, swapwindow, r"
					"$mod SHIFT, up,    swapwindow, u"
					"$mod SHIFT, down,  swapwindow, d"

					# Resizing windows                  X   Y
					"$mod CTRL, left,   resizeactive, -60   0"
					"$mod CTRL, right,  resizeactive,  60   0"
					"$mod CTRL, up,     resizeactive,   0 -60"
					"$mod CTRL, down,   resizeactive,   0  60"
					"$mod CTRL, Escape, resizeactive,   0   0"

					# Moving windows                X   Y
					"$mod ALT, left,  moveactive, -60   0"
					"$mod ALT, right, moveactive,  60   0"
					"$mod ALT, up,    moveactive,   0 -60"
					"$mod ALT, down,  moveactive,   0  60"

					# Switching workspaces
					"$mod, 1, workspace, 1"
					"$mod, 2, workspace, 2"
					"$mod, 3, workspace, 3"
					"$mod, 4, workspace, 4"
					"$mod, 5, workspace, 5"
					"$mod, 6, workspace, 6"
					"$mod, 7, workspace, 7"
					"$mod, 8, workspace, 8"
					"$mod, 9, workspace, 9"
					"$mod, 0, workspace, 10"

					"$mod, A, workspace, -1"
					"$mod, D, workspace, +1"

					"$mod, KP_Home,  workspace, 1"
					"$mod, KP_Up,    workspace, 2"
					"$mod, KP_Prior, workspace, 3"
					"$mod, KP_Left,  workspace, 4"
					"$mod, KP_Begin, workspace, 5"
					"$mod, KP_Right, workspace, 6"
					"$mod, KP_End,   workspace, 7"
					"$mod, KP_Down,  workspace, 8"
					"$mod, KP_Next,  workspace, 9"

					# Moving windows to workspaces
					"$mod SHIFT, 1, movetoworkspacesilent, 1"
					"$mod SHIFT, 2, movetoworkspacesilent, 2"
					"$mod SHIFT, 3, movetoworkspacesilent, 3"
					"$mod SHIFT, 4, movetoworkspacesilent, 4"
					"$mod SHIFT, 5, movetoworkspacesilent, 5"
					"$mod SHIFT, 6, movetoworkspacesilent, 6"
					"$mod SHIFT, 7, movetoworkspacesilent, 7"
					"$mod SHIFT, 8, movetoworkspacesilent, 8"
					"$mod SHIFT, 9, movetoworkspacesilent, 9"
					"$mod SHIFT, 0, movetoworkspacesilent, 10"

					"$mod SHIFT, A, movetoworkspace, -1"
					"$mod SHIFT, D, movetoworkspace, +1"

					# Add/remove window group
					"$mod, G, togglegroup"
					"$mod SHIFT, G, moveoutofgroup"

					# Move window to groups
					"$mod ALT, I, moveintogroup, u"
					"$mod ALT, K, moveintogroup, d"
					"$mod SHIFT, J, moveintogroup, l"
					"$mod SHIFT, L, moveintogroup, r"

					# Switch between windows in a group
					"$mod SHIFT, Tab, changegroupactive, b"
					"$mod, Tab, changegroupactive, f"

					"$mod, left, changegroupactive, b"
					"$mod, right, changegroupactive, f"

					"$mod, Z, changegroupactive, b"
					"$mod, C, changegroupactive, f"

					# Multiple monitors
					"$mod, J, focusmonitor, l"
					"$mod, L, focusmonitor, r"
					"$mod, I, focusmonitor, u"
					"$mod, K, focusmonitor, d"
					"$mod, U, movecurrentworkspacetomonitor, l"
					"$mod, O, movecurrentworkspacetomonitor, r"
					"$mod SHIFT, I, movecurrentworkspacetomonitor, u"
					"$mod SHIFT, K, movecurrentworkspacetomonitor, d"

					# Volume
					'', XF86AudioRaiseVolume,  exec, sh -c "all-ctl volume +"''
					'', XF86AudioLowerVolume,  exec, sh -c "all-ctl volume -"''
					'', XF86AudioMute,         exec, sh -c "all-ctl volume toggle"''
					'', XF86AudioMicMute,      exec, sh -c "all-ctl mic toggle"''

					# Brightness
					'', XF86MonBrightnessUp,   exec, sh -c "all-ctl brightness +"''
					''$mod, period,            exec, sh -c "all-ctl brightness +"''
					'', XF86MonBrightnessDown, exec, sh -c "all-ctl brightness -"''
					''$mod, comma,             exec, sh -c "all-ctl brightness -"''

					# Audio Playback
					'', XF86AudioNext,         exec, sh -c "all-ctl media next"''
					'', XF86AudioPause,        exec, sh -c "all-ctl media play-pause"''
					'', XF86AudioPlay,         exec, sh -c "all-ctl media play-pause"''
					'', XF86AudioPrev,         exec, sh -c "all-ctl media previous"''

					# Hyprsunset
					"$mod, M, exec, hyprctl hyprsunset identity"
					"$mod, N, exec, hyprctl hyprsunset temperature 2500K"
				]
				++ soundboardBinds;

			bindm = [
				# Move/resize windows with mainMod + LMB/RMB and dragging
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];

			# bindc = [
			# 	"$mod, mouse:272, hyprtasking:toggle, cursor"
			# ];
		};

		submaps = {
			clean = {
				settings = {
					bind = [
						"$mod, Insert, submap, reset"
					];
				};
			};
		};
	};
}
