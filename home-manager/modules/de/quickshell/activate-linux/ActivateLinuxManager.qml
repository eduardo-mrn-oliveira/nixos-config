pragma Singleton

import QtQuick

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property bool isVisible: false

	IpcHandler {
		target: "activateLinux"

		function toggle(): void {
			root.isVisible = !root.isVisible;
		}
	}
}
