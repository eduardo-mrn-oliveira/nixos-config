pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Item {
    id: root

    visible: SystemTray.items.values.length > 0

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    required property int iconSize

    property alias spacing: content.spacing

    property Item activeAnchor: null
    property var activeMenuData: null

    RowLayout {
        id: content

        anchors.fill: parent

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: item

                Layout.preferredHeight: root.iconSize
                Layout.preferredWidth: root.iconSize

                required property var modelData

                Image {
                    anchors.fill: parent

                    fillMode: Image.PreserveAspectFit

                    smooth: true
                    mipmap: true

                    source: item.modelData.icon
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton && item.modelData.activate) {
                            root.activeAnchor = null;

                            item.modelData.activate();
                        } else if (mouse.button === Qt.RightButton && item.modelData.hasMenu) {
                            if (root.activeAnchor === item) {
                                root.activeAnchor = null;
                                root.activeMenuData = null;
                            } else {
                                root.activeMenuData = item.modelData;
                                root.activeAnchor = item;
                            }
                        } else if (mouse.button === Qt.MiddleButton && item.modelData.secondaryActivate) {
                            root.activeAnchor = null;

                            item.modelData.secondaryActivate();
                        }
                    }

                    onWheel: wheel => {
                        if (item.modelData.scroll) {
                            item.modelData.scroll(wheel.angleDelta.y, false);
                            item.modelData.scroll(wheel.angleDelta.x, true);
                        }
                    }
                }
            }
        }
    }

    Loader {
        active: root.activeAnchor !== null

        sourceComponent: TrayMenu {
            anchorItem: root.activeAnchor

            qsMenuHandle: root.activeMenuData.menu

            onRequestClose: {
                root.activeAnchor = null;
                root.activeMenuData = null;
            }
        }
    }
}
