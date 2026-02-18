import QtQuick
import QtQml
import QtMultimedia
import Quickshell
import Quickshell.Wayland

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

    VideoOutput {
        id: animatedWallpaper
        anchors.fill: parent

        fillMode: VideoOutput.Stretch

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
                            VideoManager.play();
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
                            VideoManager.pause();
                        }
                    }
                }
            }
        ]

        Component.onCompleted: VideoManager.splitter.addOutput(videoSink)
        Component.onDestruction: VideoManager.splitter.removeOutput(videoSink)
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.RightButton

        onClicked: {
            Config.isAnimated = !Config.isAnimated;
        }
    }
}
