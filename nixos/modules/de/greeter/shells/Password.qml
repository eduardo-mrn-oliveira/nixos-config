import QtQuick
import QtQuick.Layouts

FocusScope {
    id: root

    property alias value: input.text

    property alias readOnly: input.readOnly

    property int minLength: 16

    readonly property color textColor: input.color
    readonly property var font: input.font

    readonly property alias minimumWidth: input.minimumWidth
    property alias preferredWidth: input.preferredWidth

    Layout.alignment: Qt.AlignHCenter
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        anchors.fill: parent

        Layout.alignment: Qt.AlignHCenter
        spacing: 0

        Text {
            text: "[ "
            color: input.color
            font: input.font
        }

        TextInput {
            id: input

            focus: true

            clip: true

            text: ""
            echoMode: TextInput.Password

            // passwordCharacter: '*'

            color: root.activeFocus ? Theme.values.textPrimary : Theme.values.textMuted

            font {
                family: Theme.values.fontMonospace
                pixelSize: Theme.values.fontSize
            }

            FontMetrics {
                id: fontMetrics
                font: input.font
            }

            readonly property int minimumWidth: fontMetrics.averageCharacterWidth * root.minLength
            property int preferredWidth: 0

            Layout.minimumWidth: minimumWidth
            Layout.preferredWidth: preferredWidth
        }

        Text {
            text: " ]"
            color: input.color
            font: input.font
        }
    }
}
