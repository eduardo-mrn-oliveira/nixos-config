pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

// qmllint disable uncreatable-type
PanelWindow {
    id: root

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    color: "transparent"

    required property Item anchorItem

    required property QsMenuHandle qsMenuHandle

    readonly property var item: QtObject {
        readonly property int radius: 8
        readonly property int separator: 8

        readonly property QtObject padding: QtObject {
            readonly property int x: 12
            readonly property int y: 4
        }
    }

    readonly property var menu: QtObject {
        readonly property int gaps: 4
        readonly property int radius: 8
        readonly property int spacing: 2
        readonly property int preferedDirection: Direction.Left

        readonly property QtObject padding: QtObject {
            readonly property int x: 4
            readonly property int y: 8
        }
    }

    signal requestClose

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onClicked: root.requestClose()
    }

    Item {
        id: backdrop
        anchors.fill: parent
    }

    TrayMenuView {
        backdrop: backdrop

        // TODO: Bottom direction

        x: {
            if (!root.anchorItem || !backdrop) {
                return 0;
            }

            const globalPoint = root.anchorItem.mapToGlobal(0, 0);

            const localPoint = backdrop.mapFromGlobal(globalPoint);

            return localPoint.x + (root.anchorItem.width - width) / 2;
        }

        y: backdrop.height - (height + menu.gaps)

        depth: 0
        visible: height > menu.padding.y * 2

        qsMenuHandle: root.qsMenuHandle

        item: root.item
        menu: root.menu

        onRequestClose: root.requestClose()
    }
}
