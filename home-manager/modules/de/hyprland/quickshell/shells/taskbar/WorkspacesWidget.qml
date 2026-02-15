import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    required property var screen

    RowLayout {
        id: content
        spacing: 0

        Repeater {
            model: Workspaces.getFor(root.screen)

            delegate: Rectangle {
                id: button

                required property int index
                required property var modelData

                property bool isFocused: Workspaces.isFocused(modelData.id)
                property bool isActive: Workspaces.isActive(modelData.id)

                property int bottomHighlightSize: 2

                implicitWidth: label.implicitWidth + 24
                implicitHeight: 38

                color: hoverHandler.containsMouse ? Theme.highlight : "transparent"

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: button.modelData.name

                    color: button.isActive ? Theme.textPrimary : Theme.textMuted

                    font {
                        family: Theme.fontMonospace
                        pixelSize: Theme.fontSize
                        bold: true
                    }
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    height: button.bottomHighlightSize
                    color: Theme.textPrimary

                    visible: button.isFocused
                }

                MouseArea {
                    id: hoverHandler

                    anchors.fill: button

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: Workspaces.switchTo(button.modelData.id)
                }
            }
        }
    }
}
