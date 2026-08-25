{
	pkgs,
	rolling,
	...
}: {
	programs.zed-editor = {
		enable = true;

		package = rolling.zed-editor;

		mutableUserDebug = false;
		mutableUserKeymaps = false;
		mutableUserSettings = false;
		mutableUserTasks = false;

		extensions = [
			"angular"
			"basher"
			"csharp"
			"deno"
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
			"xml"
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

			# Deno
			deno

			# Lua
			lua-language-server

			# Web
			prettier

			# XML
			xmlstarlet

			# Other
			package-version-server
		];

		userSettings = {
			project_panel.dock = "left";
			outline_panel.dock = "left";
			collaboration_panel.dock = "left";
			git_panel.dock = "left";
			"disable_ai" = true;
			"auto_update_extensions" = {
				"angular" = false;
				"basher" = false;
				"csharp" = false;
				"deno" = false;
				"dockerfile" = false;
				"emmet" = false;
				"git-firefly" = false;
				"github-theme" = false;
				"html" = false;
				"java" = false;
				"log" = false;
				"lua" = false;
				"make" = false;
				"material-icon-theme" = false;
				"neocmake" = false;
				"nix" = false;
				"php" = false;
				"qml" = false;
				"scss" = false;
				"sql" = false;
				"xml" = false;
				"zig" = false;
			};
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
			"default_open_behavior" = "new_window";
			"cli_default_open_behavior" = "new_window";
			inlay_hints = {
				enabled = false;
				# show_type_hints = true;
				# show_parameter_hints = true;
				# show_other_hints = true;
				show_background = true;
				# edit_debounce_ms = 700;
				# scroll_debounce_ms = 50;

				toggle_on_modifiers_press = {
					alt = true;
				};
			};
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
								"--style=file"
								"--fallback-style=none"
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
								"--style=file"
								"--fallback-style=none"
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
				"Angular" = {
					"formatter" = {
						"external" = {
							"command" = "prettier";
							"arguments" = ["--stdin-filepath" "{buffer_path}"];
						};
					};
				};
				"TypeScript" = {
					"formatter" = {
						"external" = {
							"command" = "prettier";
							"arguments" = ["--stdin-filepath" "{buffer_path}"];
						};
					};
				};
				"HTML" = {
					"formatter" = {
						"external" = {
							"command" = "prettier";
							"arguments" = ["--stdin-filepath" "{buffer_path}"];
						};
					};
				};
				"SCSS" = {
					"formatter" = {
						"external" = {
							"command" = "prettier";
							"arguments" = ["--stdin-filepath" "{buffer_path}"];
						};
					};
				};
				"JSON" = {
					"formatter" = {
						"external" = {
							"command" = "prettier";
							"arguments" = ["--stdin-filepath" "{buffer_path}"];
						};
					};
				};
				"JSONC" = {
					"formatter" = {
						"external" = {
							"command" = "prettier";
							"arguments" = ["--stdin-filepath" "{buffer_path}"];
						};
					};
				};
				"XML" = {
					"formatter" = {
						"external" = {
							"command" = "xml";
							"arguments" = ["fo" "--indent-tab" "-"];
						};
					};
				};
				"QML" = {
					"formatter" = {
						"external" = {
							"command" = "qmlformat";
						};
					};
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
						"arguments" = ["-E"];
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
				"lua-language-server" = {
					"binary" = {
						"path" = "${pkgs.lua-language-server}/bin/lua-language-server";
						"ignore_system_version" = true;
					};
				};
			};
			"load_direnv" = "direct";
			"debugger" = {
				"dock" = "right";
			};
		};

		userKeymaps = [
			{
				"bindings" = {
					"ctrl-'" = "workspace::ToggleBottomDock";

					"super-shift-p" = "command_palette::Toggle";

					"alt-f5" = "debugger::Start";
					"shift-f5" = "debugger::Stop";

					"f3" = "task::Rerun";
					"f4" = "task::Spawn";
				};
			}
		];
	};

	home.file.".clang-format".text =
		"BasedOnStyle: LLVM\n"
		+ "\n"
		+ "UseTab: Always\n"
		+ "IndentWidth: 4\n"
		+ "TabWidth: 4\n"
		+ "ColumnLimit: 100\n"
		+ "\n"
		+ "IndentCaseLabels: true\n"
		+ "\n"
		+ "AllowShortIfStatementsOnASingleLine: true\n"
		+ "AllowShortFunctionsOnASingleLine: false\n"
		+ "AllowShortBlocksOnASingleLine: false\n"
		+ "AllowShortCaseLabelsOnASingleLine: false\n"
		+ "AllowShortLoopsOnASingleLine: true\n"
		+ "\n"
		+ "PointerAlignment: Left\n"
		+ "ReferenceAlignment: Pointer\n"
		+ "\n"
		+ "AlignAfterOpenBracket: BlockIndent\n"
		+ "\n"
		+ "FixNamespaceComments: false\n"
		+ "\n";

	home.file.".prettierrc".text =
		"{\n"
		+ "\t\"useTabs\": true,\n"
		+ "\t\"tabWidth\": 4\n"
		+ "}\n";

	home.file.".config/rustfmt/rustfmt.toml".text = "hard_tabs = true\n";

	home.file.".qmlformat.ini".text =
		"[General]\n"
		+ "UseTabs=true\n"
		+ "IndentWidth=4\n";
}
