pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "./taskbar"
import "./wallpaper"

ShellRoot {
    id: root

    property var taskbar: QtObject {
        property bool visible: true
    }

    IpcHandler {
        target: "taskbar"

        function hide(): void {
            if (root.taskbar.visible) {
                root.taskbar.visible = false;
            }
        }

        function unhide(): void {
            if (!root.taskbar.visible) {
                root.taskbar.visible = true;
            }
        }

        function toggle(): void {
            root.taskbar.visible = !root.taskbar.visible;
        }

        function isVisible(): bool {
            return root.taskbar.visible;
        }
    }

    Instantiator {
        model: Quickshell.screens

        delegate: Scope {
            id: shell
            required property var modelData

            Wallpaper {
                screen: shell.modelData
            }

            Taskbar {
                visible: root.taskbar.visible

                screen: shell.modelData
            }
        }
    }
}
