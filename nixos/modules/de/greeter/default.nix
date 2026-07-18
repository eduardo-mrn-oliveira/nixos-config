{
	inputs,
	system,
	config,
	pkgs,
	lib,
	...
}: let
	cfg = config.yVanisher.greeter;

	quickshell =
		inputs.quickshell.packages.${system}.quickshell.withModules [
			pkgs.qt6.qtmultimedia
			inputs.qs-qml-types.packages.${system}.qs-qml-types
		];

	sessionType =
		lib.types.submodule {
			options = {
				name =
					lib.mkOption {
						type = lib.types.str;
						description = "The display name of the session.";
					};
				exec =
					lib.mkOption {
						type = lib.types.str;
						description = "The command or path to execute the session.";
					};
			};
		};

	flattenSessions = name: items:
		pkgs.runCommand name {} ''
			mkdir -p $out
			for item in ${pkgs.lib.escapeShellArgs items}; do
				ln -s "$item"/*.desktop "$out/"
			done
		'';

	makeSession = {
		name,
		exec,
	}:
		pkgs.writeTextDir "${name}.desktop" ''
			[Desktop Entry]
			Name=${name}
			Exec=${exec}
		'';

	graphicalSessions = flattenSessions "graphical-sessions" (map makeSession cfg.graphicalSessions);

	terminalSessions = flattenSessions "terminal-sessions" (map makeSession cfg.terminalSessions);

	launch-script =
		pkgs.writeShellScript "launch-script" ''
			export YGREETER_CONFIG=/etc/yGreeter/config.json

			# TODO: Integrate with Stylix
			# export YGREETER_THEME=/etc/yGreeter/theme.json

			export YGREETER_STATE=/var/lib/yGreeter/state.json

			${quickshell}/bin/quickshell -p ${./shells} \
				> /tmp/yGreeter/logs/quickshell.stdout.log \
				2> /tmp/yGreeter/logs/quickshell.stderr.log

			${pkgs.sway}/bin/swaymsg exit
		'';

	greeterUser = "greeter";
in {
	options.yVanisher.greeter = {
		enable = lib.mkEnableOption "yVanisher's custom greeter";

		enableDefaultSessions =
			lib.mkOption {
				type = lib.types.bool;
				default = config.yVanisher.greeter.enable;
				description = "Add default sessions to the greeter list.";
			};

		graphicalSessions =
			lib.mkOption {
				type = lib.types.listOf sessionType;
				default = [];
				description = "List of graphical sessions available to the greeter.";
			};

		terminalSessions =
			lib.mkOption {
				type = lib.types.listOf sessionType;
				default = [];
				description = "List of terminal-based sessions available to the greeter.";
			};

		extraGraphicalSessionDirs =
			lib.mkOption {
				type = lib.types.listOf (lib.types.coercedTo lib.types.str (str: str) lib.types.path);
				default = [];
				description = "Additional directories containing .desktop session files.";
			};

		extraTerminalSessionsDirs =
			lib.mkOption {
				type = lib.types.listOf (lib.types.coercedTo lib.types.str (str: str) lib.types.path);
				default = [];
				description = "Additional directories containing terminal-based .desktop session files.";
			};

		settings =
			lib.mkOption {
				description = "Configuration settings for yGreeter.";
				default = {};
				type =
					lib.types.submodule {
						options = {
							staticSource =
								lib.mkOption {
									type = lib.types.str;
									default = "";
									description = "Path to the static wallpaper image.";
								};

							staticFillMode =
								lib.mkOption {
									type = lib.types.enum ["Stretch" "PreserveAspectFit" "PreserveAspectCrop"];
									default = "Stretch";
									description = "Fill mode for the static wallpaper.";
								};

							animatedSource =
								lib.mkOption {
									type = lib.types.str;
									default = "";
									description = "Path to the animated wallpaper video.";
								};

							animatedFillMode =
								lib.mkOption {
									type = lib.types.enum ["Stretch" "PreserveAspectFit" "PreserveAspectCrop"];
									default = "Stretch";
									description = "Fill mode for the animated wallpaper.";
								};

							startEnabled =
								lib.mkOption {
									type = lib.types.bool;
									default = true;
									description = "Whether the background component starts enabled.";
								};

							startAnimated =
								lib.mkOption {
									type = lib.types.bool;
									default = false;
									description = "Whether the wallpaper starts animating immediately.";
								};

							isMuted =
								lib.mkOption {
									type = lib.types.bool;
									default = true;
									description = "Whether the video audio is muted on startup.";
								};

							volume =
								lib.mkOption {
									type = lib.types.ints.between 0 100;
									default = 0;
									description = "Startup audio volume level for animated wallpapers (0-100).";
								};
						};
					};
			};
	};

	config =
		lib.mkIf cfg.enable {
			environment.etc."yGreeter/sway-config".text = ''
				input type:pointer {
					events disabled
				}

				seat * hide_cursor -1

				input type:keyboard {
					xkb_layout br
					xkb_variant abnt2
				}

				output * bg #000000 solid_color

				exec ${launch-script}
			'';

			environment.etc."yGreeter/config.json".text =
				builtins.toJSON ({
						staticFillMode = cfg.settings.staticFillMode;
						animatedFillMode = cfg.settings.animatedFillMode;

						startEnabled = cfg.settings.startEnabled;
						startAnimated = cfg.settings.startAnimated;

						isMuted = cfg.settings.isMuted;
						volume = cfg.settings.volume;

						poweroffCmd = "/run/current-system/systemd/bin/systemctl poweroff";
						rebootCmd = "/run/current-system/systemd/bin/systemctl reboot";
						brightnessDownCmd = "${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
						brightnessUpCmd = "${pkgs.brightnessctl}/bin/brightnessctl set 10%+";

						graphicalSetupScript = "${./scripts/graphical-setup.sh}";
						terminalSetupScript = "${./scripts/terminal-setup.sh}";

						graphicalSessions = ["${graphicalSessions}"] ++ cfg.extraGraphicalSessionDirs;
						terminalSessions = ["${terminalSessions}"] ++ cfg.extraTerminalSessionsDirs;
					}
					// lib.optionalAttrs (cfg.settings.staticSource != "") {
						staticSource = cfg.settings.staticSource;
					}
					// lib.optionalAttrs (cfg.settings.animatedSource != "") {
						animatedSource = cfg.settings.animatedSource;
					});

			services.accounts-daemon.enable = true;

			services.greetd = {
				enable = true;
				settings = {
					default_session = {
						user = greeterUser;
						command =
							"${./scripts/greeter.sh}"
							+ " ${pkgs.sway}/bin/sway"
							+ " --config /etc/yGreeter/sway-config";
					};
				};
			};

			systemd.tmpfiles.rules = [
				"d /var/lib/yGreeter 0700 ${greeterUser} ${greeterUser} -"

				"d /tmp/yGreeter 0755 ${greeterUser} ${greeterUser} -"
				"d /tmp/yGreeter/mesa 0700 ${greeterUser} ${greeterUser} -"
				"d /tmp/yGreeter/logs 0755 ${greeterUser} ${greeterUser} -"
				"d /tmp/yGreeter/logs/sessions 1777 ${greeterUser} ${greeterUser} -"
			];

			yVanisher.greeter.terminalSessions =
				lib.mkIf cfg.enableDefaultSessions [
					{
						name = "Bash";
						exec = "${pkgs.bashInteractive}/bin/bash --login";
					}
				];
		};
}
