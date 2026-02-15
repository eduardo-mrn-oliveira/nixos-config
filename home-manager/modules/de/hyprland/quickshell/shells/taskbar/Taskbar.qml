pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    implicitHeight: layout.implicitHeight
    color: Theme.backgroundPrimary

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
                iconSize: Math.round(Theme.fontSize * 1.4)
                spacing: 8
            }

            ClockWidget {}
        }

        Item {
            implicitWidth: 4
        }
    }
}
