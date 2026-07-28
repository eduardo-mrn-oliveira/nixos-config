{
	inputs,
	system,
	config,
	pkgs,
	root,
	...
}: let
	colors = config.lib.stylix.colors;
	fonts = config.stylix.fonts;

	fontSize = 20;

	themeFile =
		(pkgs.formats.json {}).generate "theme.json" {
			backgroundPrimary = "#${colors.base00}";
			backgroundSecondary = "#${colors.base01}";

			highlight = "#${colors.base02}";

			textPrimary = "#${colors.base05}";
			textMuted = "#${colors.base03}";

			accent = "#${colors.base0D}";
			urgent = "#${colors.base08}";
			warning = "#${colors.base0A}";
			success = "#${colors.base0B}";

			fontMonospace = fonts.monospace.name;
			fontSansSerif = fonts.sansSerif.name;
			fontSerif = fonts.serif.name;
			fontEmoji = fonts.emoji.name;

			fontSize = fontSize;
		};

	quickshell =
		inputs.quickshell.packages.${system}.quickshell.withModules [
			pkgs.qt6.qtmultimedia
			inputs.qs-qml-types.packages.${system}.qs-qml-types
		];

	quickshellWrapped =
		pkgs.symlinkJoin {
			name = "quickshell";
			paths = [quickshell];
			nativeBuildInputs = [pkgs.makeWrapper];
			postBuild = ''
				wrapProgram $out/bin/quickshell \
				    --set YVANISHER_QS_THEME "${themeFile}" \
				    --set TZDIR "${pkgs.tzdata}/share/zoneinfo"
			'';
		};
in {
	# For some reason, GC is cleaning up the underlying package
	# That results in Quickshell being recompiled
	home.extraDependencies = [
		quickshell.unwrapped
	];

	programs.quickshell = {
		enable = true;
		systemd.enable = true;

		package = quickshellWrapped;
	};

	xdg.configFile."quickshell".source =
		config.lib.file.mkOutOfStoreSymlink "${root}/home-manager/modules/de/quickshell";
}
