pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import Qs.yVanisher.Services.Notifications

import "../config"

Rectangle {
	id: root

	required property int index
	required property Notification modelData

	required property int hoverIndex

	property bool pendingExpiration: false

	onHoverIndexChanged: {
		if (index <= hoverIndex) {
			return;
		}

		if (pendingExpiration) {
			root.modelData.requestExpire();
		}
	}

	Connections {
		target: root.modelData

		function onExpired() {
			dropAnimation.start();
		}

		function onDismissed() {
			dropAnimation.start();
		}

		function onClosed() {
			dropAnimation.start(); // TODO: Different animation?
		}

		function onTimeoutExtended() {
			if (root.modelData.hasTimeout) {
				expirationTimer.restart();
			} else {
				expirationTimer.stop();
			}
		}
	}

	MouseArea {
		anchors.fill: parent
		onClicked: root.modelData.requestDismiss()
	}

	Timer {
		id: expirationTimer
		running: root.modelData.hasTimeout
		interval: root.modelData.timeoutMs
		onTriggered: {
			if (root.index <= root.hoverIndex) {
				root.pendingExpiration = true;
			} else {
				root.modelData.requestExpire();
			}
		}
	}

	transform: Translate {
		id: translation
	}

	ParallelAnimation {
		id: dropAnimation

		NumberAnimation {
			target: translation
			property: "x"
			to: root.width
			duration: 250
			easing.type: Easing.InQuad
		}

		NumberAnimation {
			target: root
			property: "opacity"
			to: 0
			duration: 250
			easing.type: Easing.InQuad
		}

		onFinished: {
			root.modelData.requestDrop();
		}
	}

	implicitHeight: layout.implicitHeight + 24
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
			margins: 12
		}

		spacing: 12

		RowLayout {
			Layout.fillWidth: true
			spacing: 12

			Image {
				Layout.preferredWidth: 32
				Layout.preferredHeight: 32

				visible: root.modelData.icon !== ""
				source: root.modelData.icon

				fillMode: Image.PreserveAspectFit
				sourceSize.width: 64
				sourceSize.height: 64

				asynchronous: true
				cache: true
			}

			ColumnLayout {
				Layout.fillWidth: true

				spacing: 8

				Text {
					Layout.fillWidth: true

					text: root.modelData.summary
					color: Theme.values.textPrimary

					font.bold: true
					font.family: Theme.values.fontMonospace
					font.pixelSize: Theme.values.fontSize - 2

					elide: Text.ElideRight
					// wrapMode: Text.WrapAnywhere
				}

				Text {
					Layout.fillWidth: true

					visible: root.modelData.body !== ""
					text: root.modelData.body

					color: Theme.values.textPrimary

					font.family: Theme.values.fontMonospace
					font.pixelSize: Theme.values.fontSize - 3

					wrapMode: Text.Wrap

					textFormat: Text.StyledText

					onLinkActivated: function (link) {
						Qt.openUrlExternally(link);
					}

					HoverHandler {
						cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
					}
				}
			}
		}

		Image {
			Layout.fillWidth: true
			Layout.preferredHeight: {
				if (!visible || implicitWidth <= 0) {
					return 0;
				}

				return width * implicitHeight / implicitWidth;
			}

			visible: root.modelData.image !== ""
			source: root.modelData.image

			fillMode: Image.PreserveAspectFit

			asynchronous: true
			cache: true
			mipmap: true
		}

		Flow {
			id: actionsFlow
			Layout.fillWidth: true
			spacing: 8

			visible: actionsRepeater.count > 0

			readonly property real halfWidth: Math.max(0, (width - spacing) / 2)
			property var assignedWidths: []

			function recalculateLayout() {
				if (!actionsRepeater || actionsRepeater.count === 0) {
					return;
				}

				const newWidths = [];
				let i = 0;

				while (i < actionsRepeater.count) {
					const item = actionsRepeater.itemAt(i);

					if (!item) {
						return;
					}

					if (item.implicitWidth > halfWidth) {
						newWidths[i] = width;
						i++;
					} else {
						if (i + 1 < actionsRepeater.count) {
							const nextItem = actionsRepeater.itemAt(i + 1);
							if (nextItem && nextItem.implicitWidth <= halfWidth) {
								newWidths[i] = halfWidth;
								newWidths[i + 1] = halfWidth;
								i += 2;
							} else {
								newWidths[i] = width;
								i++;
							}
						} else {
							newWidths[i] = width;
							i++;
						}
					}
				}

				assignedWidths = newWidths;
			}

			onWidthChanged: recalculateLayout()
			onSpacingChanged: recalculateLayout()

			Repeater {
				id: actionsRepeater
				model: root.modelData.actions

				onCountChanged: actionsFlow.recalculateLayout()

				delegate: Item {
					id: actionDelegate
					required property int index
					required property var modelData

					implicitWidth: actionLayout.implicitWidth

					width: actionsFlow.assignedWidths[index] !== undefined ? actionsFlow.assignedWidths[index] : actionsFlow.width
					height: actionLayout.implicitHeight

					onImplicitWidthChanged: actionsFlow.recalculateLayout()
					Component.onCompleted: actionsFlow.recalculateLayout()

					RowLayout {
						id: actionLayout
						anchors.fill: parent
						spacing: 12

						Text {
							text: "("

							color: actionMouseArea.containsMouse ? Theme.values.textPrimary : Theme.values.textMuted

							font.family: Theme.values.fontMonospace
							font.pixelSize: Theme.values.fontSize - 2
						}

						Text {
							Layout.fillWidth: true

							text: actionDelegate.modelData.label

							color: actionMouseArea.containsMouse ? Theme.values.textPrimary : Theme.values.textMuted

							font.family: Theme.values.fontMonospace
							font.pixelSize: Theme.values.fontSize - 2

							horizontalAlignment: Text.AlignHCenter
							elide: Text.ElideRight
						}

						Text {
							text: ")"

							color: actionMouseArea.containsMouse ? Theme.values.textPrimary : Theme.values.textMuted

							font.family: Theme.values.fontMonospace
							font.pixelSize: Theme.values.fontSize - 2
						}
					}

					MouseArea {
						id: actionMouseArea
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: Qt.PointingHandCursor
						onClicked: actionDelegate.modelData.invoke()
					}
				}
			}
		}
	}
}
