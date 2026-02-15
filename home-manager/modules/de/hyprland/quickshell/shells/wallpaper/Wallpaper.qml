import QtQuick
import QtQml
import QtMultimedia
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "black"

    WlrLayershell.layer: WlrLayer.Background

    readonly property bool isAnimated: Config.isAnimated && Config.wallpaper.video !== null

    Image {
        id: staticWallpaper
        anchors.fill: parent

        visible: animatedWallpaper.opacity < 1

        source: Config.wallpaper.image ?? ""

        fillMode: Image.Stretch
    }

    Video {
        id: animatedWallpaper
        anchors.fill: parent

        source: Config.wallpaper.video ?? ""

        loops: MediaPlayer.Infinite
        fillMode: VideoOutput.Stretch
        muted: true

        opacity: 0
        visible: opacity > 0

        states: State {
            name: "playing"
            when: root.isAnimated
            PropertyChanges {
                animatedWallpaper.opacity: 1
            }
        }

        transitions: [
            Transition {
                from: ""
                to: "playing"
                SequentialAnimation {
                    ScriptAction {
                        script: {
                            animatedWallpaper.play();
                            // Audio.play();
                        }
                    }
                    NumberAnimation {
                        target: animatedWallpaper
                        property: "opacity"
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            },
            Transition {
                from: "playing"
                to: ""
                SequentialAnimation {
                    NumberAnimation {
                        target: animatedWallpaper
                        property: "opacity"
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                    ScriptAction {
                        script: {
                            animatedWallpaper.stop();
                            // Audio.stop();
                        }
                    }
                }
            }
        ]
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                Config.isAnimated = !Config.isAnimated;
            } else {
                Hyprland.dispatch("hyprtasking:toggle cursor");
            }
        }
    }
}
