pragma ComponentBehavior: Bound

import QtQuick

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

// qmllint disable uncreatable-type
PanelWindow {
	id: root

	readonly property var hyprlandMonitor: Hyprland.monitorFor(screen)
	readonly property bool isFocusedMonitor: hyprlandMonitor && Hyprland.focusedMonitor && hyprlandMonitor.id === Hyprland.focusedMonitor.id

	onIsFocusedMonitorChanged: {
		if (isFocusedMonitor) {
			NotificationManager.requestView(viewPanel);
		}
	}

	anchors {
		top: true
		bottom: true
		right: true
		left: true
	}

	mask: NotificationManager.viewRegion

	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay
	color: "transparent"

	Item {
		id: viewPanel
		anchors.fill: parent
	}
}
