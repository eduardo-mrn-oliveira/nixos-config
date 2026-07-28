pragma Singleton

import QtQuick

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool isVisible: true

    IpcHandler {
        target: "taskbar"

        function toggle(): void {
            root.isVisible = !root.isVisible;
        }
    }
}
