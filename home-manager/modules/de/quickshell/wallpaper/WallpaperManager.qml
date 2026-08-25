pragma Singleton

import QtQuick
import QtMultimedia

import Quickshell
import Quickshell.Io

import Qs.yVanisher.Components

Singleton {
	id: root

	property bool isWallpaperEnabled: true
	property bool isWallpaperAnimated: false

	readonly property bool shouldPlayVideo: isWallpaperEnabled && isWallpaperAnimated

	readonly property var fillModeLookup: ({
			"Stretch": {
				static: Image.Stretch,
				animated: VideoOutput.Stretch
			},
			"PreserveAspectFit": {
				static: Image.PreserveAspectFit,
				animated: VideoOutput.PreserveAspectFit
			},
			"PreserveAspectCrop": {
				static: Image.PreserveAspectCrop,
				animated: VideoOutput.PreserveAspectCrop
			}
		})

	property alias mediaController: mediaController

	MediaController {
		id: mediaController

		source: Config.values.animatedSource ? `file://${Config.values.animatedSource}` : ""
		volume: Config.values.volume
		isMuted: Config.values.isMuted
		loops: MediaPlayer.Infinite
	}

	Connections {
		target: Config.values

		function onStartEnabledChanged() {
			root.isWallpaperEnabled = Config.values.startEnabled;
		}

		function onStartAnimatedChanged() {
			root.isWallpaperAnimated = Config.values.startAnimated;
		}
	}

	IpcHandler {
		target: "wallpaper"

		function toggle(): void {
			root.isWallpaperEnabled = !root.isWallpaperEnabled;
		}

		function toggleAnimation(): void {
			root.isWallpaperAnimated = !root.isWallpaperAnimated;
		}

		function playPause(): void {
			if (root.shouldPlayVideo) {
				mediaController.playPause();
			}
		}

		function muteUnmute(): void {
			Config.values.isMuted = !Config.values.isMuted;
		}

		function volumeDown(): void {
			const volume = Config.values.volume;
			Config.values.volume = Math.max(volume - 10, 0);
		}

		function volumeUp(): void {
			const volume = Config.values.volume;
			Config.values.volume = Math.min(volume + 10, 100);
		}
	}
}
