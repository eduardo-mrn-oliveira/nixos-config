pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

Rectangle {
    id: root

    color: Theme.backgroundSecondary

    implicitHeight: content.implicitHeight + root.menu.padding.y * 2
    implicitWidth: content.implicitWidth + root.menu.padding.x * 2

    radius: root.menu.radius

    z: depth * 10

    visible: false

    border.width: 1
    border.color: Qt.lighter(color, 1.5)

    RectangularShadow {
        anchors.fill: parent
        z: -1
        radius: parent.radius
        spread: 1
        color: "#80000000"
        offset: Qt.vector2d(root.menu.padding.x, root.menu.padding.y)
    }

    property QsMenuHandle qsMenuHandle

    property var item: QtObject {
        readonly property int radius: 8
        readonly property int separator: 8

        readonly property QtObject padding: QtObject {
            readonly property int x: 12
            readonly property int y: 4
        }
    }

    property var menu: QtObject {
        readonly property int gaps: 4
        readonly property int radius: 8
        readonly property int spacing: 2
        readonly property int preferedDirection: Direction.Left

        readonly property QtObject padding: QtObject {
            readonly property int x: 4
            readonly property int y: 8
        }
    }

    property Item backdrop: null
    property Item parentMenu: null
    property Item anchorItem: null

    property var menuState: ({})

    property int depth: -1

    signal requestClose

    onImplicitHeightChanged: {
        if (depth === 0 || !backdrop || !anchorItem) {
            return;
        }

        const globalPoint = root.mapToItem(backdrop, x, y);

        if (menu.preferedDirection !== Direction.Left) {
            // TODO: Right direction
            return;
        }

        const anchor = {
            x: 0,
            y: 0
        };

        if (globalPoint.x >= (width + menu.gaps * 2)) {
            // Left
            anchor.x = globalPoint.x - (width + menu.gaps);
        } else {
            // Right
            anchor.x = globalPoint.x + (parentMenu.width + menu.gaps);
        }

        if ((backdrop.height - (globalPoint.y + anchorItem.y)) >= (height + menu.gaps)) {
            // Normal
            anchor.y = globalPoint.y + anchorItem.y;
        } else {
            // Clip up
            anchor.y = backdrop.height - (height + menu.gaps);
        }

        const localPoint = backdrop.mapToItem(root, anchor.x, anchor.y);

        x = localPoint.x;
        y = localPoint.y;
    }

    QsMenuOpener {
        id: qsMenu
        menu: root.qsMenuHandle
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: mouse => mouse.accepted = true
        onWheel: wheel => wheel.accepted = true
    }

    ColumnLayout {
        id: content

        anchors.top: parent.top
        anchors.topMargin: root.menu.padding.y

        anchors.left: parent.left
        anchors.leftMargin: root.menu.padding.x

        anchors.right: parent.right
        anchors.rightMargin: root.menu.padding.x

        spacing: root.menu.gaps

        Repeater {
            id: repeater
            model: qsMenu.children

            delegate: Item {
                id: item

                required property var index
                required property var modelData

                readonly property bool isSeparator: modelData ? modelData.isSeparator : true

                readonly property bool isHovered: !isSeparator && hoverHandler.containsMouse

                readonly property bool isHighlighted: isHovered || (root.menuState[root.depth] === item.index)

                // readonly property bool isHighlighted: isHovered || (root.menuState[root.depth] === item.index && root.menuState[root.depth + 1] !== -1)

                readonly property var iconMap: ({
                        [QsMenuButtonType.CheckBox]: {
                            [Qt.Unchecked]: "󰄱 ",
                            [Qt.PartiallyChecked]: "󰡖 ",
                            [Qt.Checked]: "󰱒 "
                        },
                        [QsMenuButtonType.RadioButton]: {
                            [Qt.Unchecked]: "󰄰 ",
                            [Qt.PartiallyChecked]: "󰐾 ",
                            [Qt.Checked]: "󰐾 "
                        }
                    })

                readonly property string icon: iconMap[modelData.buttonType]?.[modelData.checkState] ?? (modelData.hasChildren ? " " : "")

                implicitHeight: isSeparator ? root.item.separator : text.implicitHeight
                implicitWidth: isSeparator ? 0 : text.implicitWidth

                z: qsMenu.children.values.length - index

                Layout.fillWidth: true

                Rectangle {
                    anchors.fill: item

                    visible: !item.isSeparator

                    color: item.isHighlighted ? Theme.highlight : "transparent"
                    radius: root.item.radius
                }

                Text {
                    id: text

                    visible: !item.isSeparator

                    leftPadding: root.item.padding.x
                    rightPadding: root.item.padding.x

                    topPadding: root.item.padding.y
                    bottomPadding: root.item.padding.y

                    text: item.icon + item.modelData.text
                    color: Theme.textPrimary

                    font {
                        family: Theme.fontMonospace
                        pixelSize: Theme.fontSize
                    }
                }

                MouseArea {
                    id: hoverHandler

                    visible: !item.isSeparator

                    anchors.fill: item

                    cursorShape: Qt.PointingHandCursor

                    hoverEnabled: true
                    propagateComposedEvents: false
                    preventStealing: true

                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: mouse => {
                        if (item.modelData.hasChildren) {
                            // Close/open on left/right click

                            root.menuState[root.depth] = subMenuLoader.active ? -1 : item.index;
                            root.menuState[root.depth + 1] = -1;

                            root.menuStateChanged();

                            subMenuLoader.active = !subMenuLoader.active;

                            return;
                        }

                        if (mouse.button === Qt.RightButton) {
                            return;
                        }

                        item.modelData.triggered();

                        if (item.modelData.buttonType === QsMenuButtonType.None) {
                            root.requestClose();
                        }

                        mouse.accepted = true;
                    }

                    // Note: If the menu logic recreates items during updates, the cursor
                    // will briefly reset to default.
                    Timer {
                        interval: 0
                        running: true
                        onTriggered: {
                            parent.enabled = false;
                            parent.enabled = true;
                        }
                    }
                }

                onIsHoveredChanged: {
                    if (isHovered && root.menuState[root.depth] !== item.index) {
                        root.menuState[root.depth] = item.index;
                        root.menuState[root.depth + 1] = -1;

                        root.menuStateChanged();

                        if (item.modelData.hasChildren) {
                            subMenuLoader.active = false;
                            subMenuLoader.active = true;
                        } else {
                            subMenuLoader.active = false;
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: subMenuLoader
        active: false

        z: root.depth * 10 + 5

        source: "TrayMenuView.qml"

        readonly property TrayMenuView subMenu: subMenuLoader.item as TrayMenuView

        Component.onCompleted: {
            const index = root.menuState[root.depth];

            active = (index !== undefined && index !== -1 && qsMenu.children.values[index]);
        }

        Binding {
            target: subMenuLoader.item
            property: "qsMenuHandle"
            value: qsMenu.children.values[root.menuState[root.depth]]
            when: subMenuLoader.status === Loader.Ready
        }

        onLoaded: {
            const selectedIndex = root.menuState[root.depth];

            const selectedItem = repeater.itemAt(selectedIndex);

            subMenu.backdrop = root.backdrop;
            subMenu.parentMenu = root;
            subMenu.anchorItem = selectedItem;

            subMenu.item = root.item;
            subMenu.menu = root.menu;

            subMenu.menuState = root.menuState;
            subMenu.depth = root.depth + 1;

            const checkAndShow = () => {
                if (subMenu.implicitHeight > (subMenu.menu.padding.y * 2)) {
                    subMenu.visible = true;
                    subMenu.implicitHeightChanged.disconnect(checkAndShow);
                }
            };

            subMenu.implicitHeightChanged.connect(checkAndShow);
        }

        Connections {
            target: subMenuLoader.subMenu

            function onMenuStateChanged() {
                root.menuStateChanged();
            }

            function onRequestClose() {
                root.requestClose();
            }
        }
    }
}
