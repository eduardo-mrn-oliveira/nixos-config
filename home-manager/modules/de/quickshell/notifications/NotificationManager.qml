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
				supportsBodyHyperlinks: true,
				supportsBodyMarkup: true,
				supportsIcon: true,
				supportsImage: true,
				supportsActions: true,
				supportsActionIcons: false,
				supportsPersistence: false,
				defaultExpireTimeoutMs: 2500,
				forceImageAsIconApps: ["vesktop", "discord", "org.gnome.Nautilus"]
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
