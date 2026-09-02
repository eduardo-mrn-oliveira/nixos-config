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
			expirationTimer.restart();
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

				spacing: 4

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

					wrapMode: Text.WrapAnywhere

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
	}
}
