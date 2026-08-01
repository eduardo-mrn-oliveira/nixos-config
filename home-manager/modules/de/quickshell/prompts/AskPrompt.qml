import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import Quickshell
import Quickshell.Wayland

import "../config"

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    required property string message
    required property string callbackCommand

    Rectangle {
        anchors.fill: parent

        color: Qt.rgba(0, 0, 0, 0.6)

        MouseArea {
            anchors.fill: parent

            onClicked: PromptManager.closePrompt()
        }
    }

    Rectangle {
        id: surface

        width: Math.max(320, Math.min(layout.implicitWidth + 40, 640))
        height: layout.implicitHeight + 40
        anchors.centerIn: parent

        radius: 12

        color: Theme.values.backgroundPrimary
        border.color: Theme.values.textMuted
        border.width: 1

        RectangularShadow {
            anchors.fill: parent
            z: -1

            radius: parent.radius
            spread: 1
            color: "#80000000"

            offset: Qt.vector2d(4, 8)
        }

        ColumnLayout {
            id: layout

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 20
            }

            spacing: 20

            Text {
                Layout.fillWidth: true
                Layout.maximumWidth: 600

                text: root.message
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap

                color: Theme.values.textPrimary

                font.family: Theme.values.fontMonospace
                font.pixelSize: Theme.values.fontSize
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.values.fontSize * 2.5
                spacing: 0

                Text {
                    text: "[ "
                    color: inputBox.activeFocus ? Theme.values.textPrimary : Theme.values.textMuted
                    font.family: Theme.values.fontMonospace
                    font.pixelSize: Theme.values.fontSize
                }

                TextInput {
                    id: inputBox

                    Layout.fillWidth: true
                    verticalAlignment: TextInput.AlignVCenter
                    clip: true

                    color: activeFocus ? Theme.values.textPrimary : Theme.values.textMuted

                    font.family: Theme.values.fontMonospace
                    font.pixelSize: Theme.values.fontSize

                    Component.onCompleted: forceActiveFocus()

                    Keys.onEscapePressed: PromptManager.closePrompt()
                    onAccepted: {
                        if (root.callbackCommand !== "") {
                            const cmd = root.callbackCommand.includes("$1") ? root.callbackCommand : root.callbackCommand + ' "$1"';
                            Quickshell.execDetached(["sh", "-c", cmd, "--", text]);
                        }
                        PromptManager.closePrompt();
                    }
                }

                Text {
                    text: " ]"
                    color: inputBox.activeFocus ? Theme.values.textPrimary : Theme.values.textMuted
                    font.family: Theme.values.fontMonospace
                    font.pixelSize: Theme.values.fontSize
                }
            }
        }
    }
}
