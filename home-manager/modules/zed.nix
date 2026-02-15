{
	pkgs,
	config,
	...
}: {
	programs.zed-editor = {
		enable = true;

		extensions = [
			"angular"
			"basher"
			"csharp"
			"dockerfile"
			"emmet"
			"git-firefly"
			"github-theme"
			"html"
			"java"
			"log"
			"lua"
			"make"
			"material-icon-theme"
			"neocmake"
			"nix"
			"php"
			"qml"
			"scss"
			"sql"
			"zig"
		];

		extraPackages = with pkgs; [
			# C/C++
			clang-tools

			# CMake
			neocmakelsp

			# Python
			pyright
			black

			# Nix
			nil
			nixd
			alejandra

			# Java
			jdt-language-server
			openjdk21

			# PHP
			phpactor

			# Qt
			qt6.qtdeclarative

			# Other
			package-version-server
			nodePackages.prettier
		];

		userSettings = {
			"base_keymap" = "VSCode";
			"telemetry" = {
				"diagnostics" = false;
				"metrics" = false;
			};
			"icon_theme" = "Material Icon Theme";
			"ui_font_family" = "FiraCode Nerd Font";
			"buffer_font_family" = "FiraCode Nerd Font";
			"ui_font_size" = 18;
			"buffer_font_size" = 16;
			"theme" = {
				"mode" = "system";
				"light" = "GitHub Dark";
				"dark" = "GitHub Dark";
			};
			"format_on_save" = "on";
			"languages" = {
				"C" = {
					"formatter" = {
						"external" = {
							"command" = "clang-format";
							"arguments" = [
								"--style={UseTab: Always, IndentWidth: 4, TabWidth: 4, IndentCaseLabels: true, AllowShortIfStatementsOnASingleLine: true, AllowShortFunctionsOnASingleLine: false, AllowShortBlocksOnASingleLine: false, AllowShortCaseLabelsOnASingleLine: false, AllowShortLoopsOnASingleLine: true}"
								"--assume-filename={buffer_path}"
							];
						};
					};
				};
				"C++" = {
					"formatter" = {
						"external" = {
							"command" = "clang-format";
							"arguments" = [
								"--style={UseTab: Always, IndentWidth: 4, TabWidth: 4, IndentCaseLabels: true, AllowShortIfStatementsOnASingleLine: true, AllowShortFunctionsOnASingleLine: false, AllowShortBlocksOnASingleLine: false, AllowShortCaseLabelsOnASingleLine: false, AllowShortLoopsOnASingleLine: true, FixNamespaceComments: false}"
								"--assume-filename={buffer_path}"
							];
						};
					};
				};
				"Python" = {
					"language_servers" = ["pyright"];
					"formatter" = {
						"external" = {
							"command" = "black";
							"arguments" = ["-"];
						};
					};
					"hard_tabs" = false;
				};
				"Nix" = {
					"formatter" = {
						"external" = {
							"command" = "alejandra";
							"arguments" = ["--quiet" "--"];
						};
					};
				};
				"Java" = {
					"hard_tabs" = false;
				};
				"Plain Text" = {
					"ensure_final_newline_on_save" = false;
				};
			};
			"tab_size" = 4;
			"hard_tabs" = true;
			"soft_wrap" = "editor_width";
			"lsp" = {
				"pyright" = {
					"settings" = {
						"python.analysis" = {
							"diagnosticMode" = "workspace";
							"typeCheckingMode" = "strict";
						};
					};
				};
				"qml" = {
					"binary" = {
						"arguments" = [
							"-I"
							"${config.programs.quickshell.package}/lib/qt-6/qml"
							"-I"
							"${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
							"-I"
							"${pkgs.qt6.qtmultimedia}/lib/qt-6/qml"
						];
					};
				};
				"nil" = {
					"settings" = {
						"nix" = {
							# "maxMemoryMB" = 2560;
							"flake" = {
								"autoArchive" = true;
								# "autoEvalInputs" = true;
								"nixpkgsInputName" = "nixpkgs";
							};
						};
					};
				};
			};
			"debugger" = {
				"dock" = "right";
			};
		};

		userKeymaps = [
			{
				"context" = "Workspace";
				"bindings" = {
					"ctrl-'" = "workspace::ToggleBottomDock";
					"super-shift-p" = "command_palette::Toggle";

					"alt-x" = [
						"task::Spawn"
						{
							"task_name" = "Build active file";
							"reveal_target" = "dock";
						}
					];

					"alt-c" = [
						"task::Spawn"
						{
							"task_name" = "Test active file";
							"reveal_target" = "dock";
						}
					];
				};
			}
			{
				"context" = "Editor";
				"bindings" = {
					"ctrl-'" = "workspace::ToggleBottomDock";
				};
			}
		];
	};
}
