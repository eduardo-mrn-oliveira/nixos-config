import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland

// qmllint disable uncreatable-type
PanelWindow {
    visible: ActivateLinuxManager.isVisible

    anchors {
        right: true
        bottom: true
    }

    // qmllint disable unresolved-type unqualified missing-property
    margins {
        right: 20
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
