{config, ...}: let
	colors = config.lib.stylix.colors;
	fonts = config.stylix.fonts;

	# fontSize = config.stylix.fonts.sizes.terminal;
	fontSize = 20;
in ''
	pragma Singleton

	import QtQuick
	import Quickshell

	Singleton {
		readonly property color backgroundPrimary: "#${colors.base00}"
		readonly property color backgroundSecondary: "#${colors.base01}"

		readonly property color highlight: "#${colors.base02}"

		readonly property color textPrimary: "#${colors.base05}"
		readonly property color textMuted: "#${colors.base03}"

		readonly property color accent: "#${colors.base0D}"
		readonly property color urgent: "#${colors.base08}"

		readonly property string fontMonospace: "${fonts.monospace.name}"
		readonly property string fontSansSerif: "${fonts.sansSerif.name}"
		readonly property string fontSerif: "${fonts.serif.name}"
		readonly property string fontEmoji: "${fonts.emoji.name}"

		readonly property int fontSize: ${toString fontSize}
	}
''
