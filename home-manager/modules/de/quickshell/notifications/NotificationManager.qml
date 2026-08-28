pragma Singleton

import QtQuick

import Quickshell

import Qs.yVanisher.Services.Notifications

Singleton {
	Timer {
		id: registrationTimer

		running: true
		repeat: false
		interval: 2000
		triggeredOnStart: true

		property int attempts: 5

		onTriggered: {
			if (NotificationServer.isRegistered) {
				return;
			}

			--attempts;

			const registered = NotificationServer.tryRegister({
				supportsBody: true,
				supportsBodyHyperlinks: false,
				supportsBodyMarkup: false,
				supportsIcon: true,
				supportsImage: false,
				supportsActions: false,
				supportsActionIcons: false,
				supportsPersistence: false,
				defaultExpireTimeoutMs: 2500
			});

			if (!registered && attempts >= 0) {
				registrationTimer.restart();
			}
		}
	}

	NotificationView {
		id: view
	}

	property alias viewRegion: view.region

	function requestView(container: Item) {
		view.moveTo(container);
	}
}
