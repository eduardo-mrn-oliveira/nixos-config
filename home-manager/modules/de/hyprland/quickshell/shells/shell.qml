pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
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

    property var wallpaper: QtObject {
        property bool visible: true
    }

    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            root.wallpaper.visible = !root.wallpaper.visible;

            if (root.wallpaper.visible && Config.isAnimated) {
                VideoManager.play();
            } else {
                VideoManager.pause();
            }
        }

        function toggleAnimation(): void {
            if (root.wallpaper.visible) {
                Config.isAnimated = !Config.isAnimated;
            }
        }

        function playPause(): void {
            if (root.wallpaper.visible) {
                VideoManager.playPause();
            }
        }
    }

    property var activateLinux: QtObject {
        property bool visible: false
    }

    IpcHandler {
        target: "activateLinux"

        function toggle(): void {
            root.activateLinux.visible = !root.activateLinux.visible;
        }
    }

    Instantiator {
        model: Quickshell.screens

        delegate: Scope {
            id: shell
            required property var modelData

            Wallpaper {
                visible: root.wallpaper.visible

                screen: shell.modelData
            }

            Taskbar {
                visible: root.taskbar.visible

                screen: shell.modelData
            }

            // qmllint disable uncreatable-type
            PanelWindow {
                visible: root.activateLinux.visible

                screen: shell.modelData

                anchors {
                    right: true
                    bottom: true
                }

                // qmllint disable unresolved-type unqualified missing-property
                margins {
                    right: 50
                    bottom: 20
                }

                implicitWidth: content.width
                implicitHeight: content.height

                color: "transparent"

                mask: Region {}
                WlrLayershell.layer: WlrLayer.Overlay

                ColumnLayout {
                    id: content

                    Text {
                        text: "Activate Linux"
                        color: "#50ffffff"
                        font.pointSize: 22
                    }

                    Text {
                        text: "Go to Settings to activate Linux"
                        color: "#50ffffff"
                        font.pointSize: 14
                    }
                }
            }
        }
    }
}
