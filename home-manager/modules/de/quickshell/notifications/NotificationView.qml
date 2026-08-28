pragma ComponentBehavior: Bound

import QtQuick

import Quickshell

import Qs.yVanisher.Services.Notifications

Item {
	id: root

	function moveTo(container: Item) {
		root.parent = container;
	}

	// This may act weird sometimes
	property Region region: Region {}

	property int hoverIndex: -1

	width: 360

	anchors {
		top: parent ? parent.top : undefined
		right: parent ? parent.right : undefined
		bottom: parent ? parent.bottom : undefined
		margins: 12
	}

	Column {
		width: parent.width

		spacing: 12

		y: Math.min(0, root.height - implicitHeight)

		Behavior on y {
			NumberAnimation {
				duration: 250
				easing.type: Easing.OutQuad
			}
		}

		move: Transition {
			NumberAnimation {
				property: "y"
				duration: 250
				easing.type: Easing.OutQuad
			}
		}

		Repeater {
			model: NotificationServer.transientNotifications

			delegate: NotificationCard {
				id: card
				hoverIndex: root.hoverIndex
				width: root.width

				Region {
					id: cardRegion
					item: card
				}

				Timer {
					id: unhoverTimer
					interval: 200
					repeat: false
					onTriggered: {
						if (root.hoverIndex === card.index) {
							root.hoverIndex = -1;
						}
					}
				}

				HoverHandler {
					onHoveredChanged: {
						if (hovered) {
							unhoverTimer.stop();
							root.hoverIndex = card.index;
						} else if (root.hoverIndex === card.index) {
							unhoverTimer.restart();
						}
					}
				}

				Component.onCompleted: {
					root.region.regions.push(cardRegion);
				}

				Component.onDestruction: {
					root.region.regions = root.region.regions.filter(region => region !== cardRegion);
				}
			}
		}
	}
}
