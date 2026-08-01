pragma ComponentBehavior: Bound

import QtQuick
import QtMultimedia
import Quickshell
import Quickshell.Wayland
import Qs.yVanisher.Components

ShellRoot {
    id: root

    // Background

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

    Connections {
        target: Config.values

        function onStartEnabledChanged() {
            root.isWallpaperEnabled = Config.values.startEnabled;
        }

        function onStartAnimatedChanged() {
            root.isWallpaperAnimated = Config.values.startAnimated;
        }
    }

    MediaController {
        id: mediaController

        source: Config.values.animatedSource ? `file://${Config.values.animatedSource}` : ""

        volume: Config.values.volume
        isMuted: Config.values.isMuted

        loops: MediaPlayer.Infinite
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Scope {
                id: scope

                required property var modelData
                readonly property int index: Quickshell.screens.indexOf(modelData)

                // qmllint disable uncreatable-type
                PanelWindow {
                    id: window

                    anchors {
                        top: true
                        bottom: true
                        left: true
                        right: true
                    }

                    WlrLayershell.layer: WlrLayer.Overlay
                    focusable: scope.index === 0

                    screen: scope.modelData
                    color: "black"

                    Shortcuts {
                        target: root
                        mediaController: mediaController
                    }

                    AnimatedBackground {
                        anchors.fill: parent
                        visible: root.isWallpaperEnabled

                        hasControlOverMedia: scope.index === 0
                        mediaController: mediaController
                        isAnimated: root.shouldPlayVideo

                        staticSource: Config.values.staticSource ? `file://${Config.values.staticSource}` : ""
                        staticFillMode: root.fillModeLookup[Config.values.staticFillMode]?.static ?? Image.PreserveAspectFit

                        animatedFillMode: root.fillModeLookup[Config.values.animatedFillMode]?.animated ?? VideoOutput.PreserveAspectFit
                    }

                    Loader {
                        active: scope.index === 0
                        asynchronous: true

                        anchors.fill: parent
                        source: "GreeterSurface.qml"
                    }
                }
            }
        }
    }
}
