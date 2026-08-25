pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../config"

// qmllint disable uncreatable-type
PanelWindow {
	id: root

	visible: TaskbarManager.isVisible

	implicitHeight: layout.implicitHeight
	color: Theme.values.backgroundPrimary

	WlrLayershell.namespace: "taskbar"

	anchors {
		left: true
		right: true
		bottom: true
	}

	RowLayout {
		id: layout

		anchors {
			left: parent.left
			right: parent.right
		}

		WorkspacesWidget {
			screen: root.screen
		}

		Item {
			Layout.fillWidth: true
		}

		RowLayout {
			spacing: 18

			NetworkWidget {}

			AudioWidget {}

			BatteryWidget {}

			TrayWidget {
				iconSize: Math.round(Theme.values.fontSize * 1.4)
				spacing: 8
			}

			ClockWidget {}
		}

		Item {
			implicitWidth: 4
		}
	}
}
