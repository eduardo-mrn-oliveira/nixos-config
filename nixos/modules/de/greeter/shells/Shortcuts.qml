import QtQuick
import Quickshell
import Qs.yVanisher.Components
import Qs.yVanisher.System.Greeter

Item {
	id: root

	required property var target
	required property MediaController mediaController

	Shortcut {
		enabled: Config.values.poweroffCmd !== ""

		sequence: "F1"
		autoRepeat: false
		onActivated: Quickshell.execDetached(["sh", "-c", Config.values.poweroffCmd])
	}

	Shortcut {
		enabled: Config.values.rebootCmd !== ""

		sequence: "F2"
		autoRepeat: false
		onActivated: Quickshell.execDetached(["sh", "-c", Config.values.rebootCmd])
	}

	Shortcut {
		enabled: Config.values.brightnessDownCmd !== ""

		sequence: "F3"
		autoRepeat: false
		onActivated: Quickshell.execDetached(["sh", "-c", Config.values.brightnessDownCmd])
	}

	Shortcut {
		enabled: Config.values.brightnessUpCmd !== ""

		sequence: "F4"
		autoRepeat: false
		onActivated: Quickshell.execDetached(["sh", "-c", Config.values.brightnessUpCmd])
	}

	Shortcut {
		sequence: "F5"
		autoRepeat: false
		onActivated: Greeter.refresh()
	}

	Shortcut {
		sequence: "Shift+F5"
		autoRepeat: false
		onActivated: {
			Quickshell.reload(false);
		}
	}

	Shortcut {
		sequence: "Ctrl+Shift+F5"
		autoRepeat: false
		onActivated: {
			Quickshell.reload(true);
		}
	}

	Shortcut {
		sequence: "Esc"
		autoRepeat: false
		onActivated: {
			Qt.callLater(Qt.quit);
		}
	}

	Scope {
		id: background

		function toggle(): void {
			root.target.isWallpaperEnabled = !root.target.isWallpaperEnabled;
		}

		function toggleAnimation(): void {
			root.target.isWallpaperAnimated = !root.target.isWallpaperAnimated;
		}

		function playPause(): void {
			if (root.target.shouldPlayVideo) {
				root.mediaController.playPause();
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

	// Background control

	Shortcut {
		sequence: "Meta+J"
		autoRepeat: false
		onActivated: background.toggle()
	}

	Shortcut {
		sequence: "Meta+K"
		autoRepeat: false
		onActivated: background.toggleAnimation()
	}

	Shortcut {
		sequence: "Meta+L"
		autoRepeat: false
		onActivated: background.playPause()
	}

	// Audio control

	Shortcut {
		sequence: "Meta+M"
		autoRepeat: false
		onActivated: background.muteUnmute()
	}

	Shortcut {
		sequence: "Meta+,"
		autoRepeat: true
		onActivated: background.volumeDown()
	}

	Shortcut {
		sequence: "Meta+."
		autoRepeat: true
		onActivated: background.volumeUp()
	}
}
