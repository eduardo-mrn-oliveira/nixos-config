{config, ...}: let
	# fontSize = config.stylix.fonts.sizes.terminal;
	fontSize = 20;
in ''
	pragma Singleton

	import QtQuick
	import Quickshell

	Singleton {
		readonly property color backgroundPrimary: "#${config.lib.stylix.colors.base00}"
		readonly property color backgroundSecondary: "#${config.lib.stylix.colors.base01}"

		readonly property color highlight: "#${config.lib.stylix.colors.base02}"

		readonly property color textPrimary: "#${config.lib.stylix.colors.base05}"
		readonly property color textMuted: "#${config.lib.stylix.colors.base03}"

		readonly property color accent: "#${config.lib.stylix.colors.base0D}"
		readonly property color urgent: "#${config.lib.stylix.colors.base08}"

		readonly property string fontMonospace: "${config.stylix.fonts.monospace.name}"
		readonly property string fontSansSerif: "${config.stylix.fonts.sansSerif.name}"
		readonly property string fontSerif: "${config.stylix.fonts.serif.name}"
		readonly property string fontEmoji: "${config.stylix.fonts.emoji.name}"

		readonly property int fontSize: ${toString fontSize}
	}
''
