{config, ...}: let
	isAnimated =
		if config.theming.wallpaper.startAnimated
		then "true"
		else "false";

	isMuted =
		if config.theming.wallpaper.isMuted
		then "true"
		else "false";

	wallpaper = {
		image =
			if config.theming.wallpaper.image != null
			then "\"file://${config.theming.wallpaper.image}\""
			else "null";

		video =
			if config.theming.wallpaper.video != null
			then "\"file://${config.theming.wallpaper.video}\""
			else "null";
	};
in ''
	pragma Singleton

	import QtQuick
	import Quickshell

	Singleton {
		property bool isAnimated: ${isAnimated}
		property bool isMuted: ${isMuted}

		readonly property var wallpaper: QtObject {
			readonly property var image: ${wallpaper.image}
			readonly property var video: ${wallpaper.video}
		}
	}
''
