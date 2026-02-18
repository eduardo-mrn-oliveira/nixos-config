{config, ...}: let
	cfg = config.theming.wallpaper;

	isAnimated = builtins.toJSON cfg.startAnimated;
	isMuted = builtins.toJSON cfg.isMuted;

	volume = builtins.toJSON cfg.volume;

	wallpaper = {
		image =
			if cfg.image != null
			then "\"file://${cfg.image}\""
			else "null";

		video =
			if cfg.video != null
			then "\"file://${cfg.video}\""
			else "null";
	};
in ''
	pragma Singleton
	import QtQuick
	import Quickshell

	Singleton {
	    property bool isAnimated: ${isAnimated}
	    property bool isMuted: ${isMuted}
	    property int volume: ${volume}

	    readonly property var wallpaper: QtObject {
	        readonly property var image: ${wallpaper.image}
	        readonly property var video: ${wallpaper.video}
	    }
	}
''
