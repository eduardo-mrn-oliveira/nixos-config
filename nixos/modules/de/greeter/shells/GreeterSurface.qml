import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Greetd
import Qs.yVanisher.System.Greeter

Item {
	id: root
	anchors.fill: parent

	Connections {
		target: Greetd

		function onAuthMessage(message, error, responseRequired, echoResponse) {
			if (responseRequired) {
				Greetd.respond(passwordInput.value);
			} else if (error) {
				statusMessage.currentError = message;
			}
		}

		function onAuthFailure(message) {
			statusMessage.currentError = "Authentication failed";

			passwordInput.forceActiveFocus();
			content.readOnly = false;
		}

		function onError(message) {
			if (message.includes("os error 111")) {
				return; // Ignore
			}

			content.readOnly = false;
		}

		function onReadyToLaunch() {
			const session = Greeter.availableSessions[sessionSelector.index] as Session;

			const type = session.type;
			const exec = session.exec;

			if (type == Session.Type.Graphical) {
				if (Config.values.graphicalSetupScript) {
					Greetd.launch([Config.values.graphicalSetupScript, exec]);
				} else {
					Greetd.launch(["sh", "-c", exec]);
				}
			} else {
				if (Config.values.terminalSetupScript) {
					Greetd.launch([Config.values.terminalSetupScript, exec]);
				} else {
					Greetd.launch(["sh", "-c", exec]);
				}
			}
		}
	}

	Shortcut {
		sequences: ["Meta+W", "Up"]
		onActivated: {
			content.index = (content.index - 1 + content.inputs.length) % content.inputs.length;
		}
	}

	Shortcut {
		sequences: ["Meta+S", "Down"]
		onActivated: {
			content.index = (content.index + 1) % content.inputs.length;
		}
	}

	Shortcut {
		enabled: !content.readOnly

		sequences: ["Return", "Enter"]
		autoRepeat: false

		onActivated: {
			statusMessage.currentError = "";
			content.readOnly = true;

			const session = sessionSelector.value;
			const username = userSelector.value;

			if (LastState.values.lastSession != session) {
				LastState.values.lastSession = session;
			}

			if (LastState.values.lastUsername != username) {
				LastState.values.lastUsername = username;
			}

			Greetd.createSession(username);
		}
	}

	Shortcut {
		sequences: ["Meta+H"]
		onActivated: {
			if (container.opacity === 0.0) {
				container.opacity = 1.0;
			} else {
				container.opacity = 0.0;
			}
		}
	}

	Rectangle {
		id: container

		anchors.centerIn: parent

		implicitWidth: content.implicitWidth + 48
		implicitHeight: content.implicitHeight + 48

		radius: 12

		color: Theme.values.backgroundPrimary

		border {
			color: Theme.values.textMuted
			width: 1
		}

		opacity: 0.0

		Behavior on opacity {
			NumberAnimation {
				duration: 250
				easing.type: Easing.InOutQuad
			}
		}

		Timer {
			id: fadeTimer
			interval: 350
			running: true
			repeat: false
			onTriggered: container.opacity = 1.0
		}

		GridLayout {
			id: content
			anchors.centerIn: parent

			rowSpacing: 24
			columnSpacing: 24
			columns: 2

			property int index: -1
			property list<var> inputs: [sessionSelector, userSelector, passwordInput]

			property int preferredWidth: Math.max(sessionSelector.minimumWidth, userSelector.minimumWidth, passwordInput.minimumWidth)
			property bool readOnly: false

			onIndexChanged: {
				inputs[index].forceActiveFocus();
			}

			Text {
				id: statusMessage

				Layout.columnSpan: 2
				Layout.alignment: Qt.AlignHCenter

				property string currentError: ""

				function formatState(state) {
					switch (state) {
					case GreetdState.Authenticating:
						return "Authenticating...";
					case GreetdState.ReadyToLaunch:
						return "Authentication successful";
					case GreetdState.Launching:
						return "Starting session...";
					case GreetdState.Launched:
						return "Session launched";
					default:
						return Greeter.hostName;
					}
				}

				color: {
					if (!Greetd.available) {
						return Theme.values.urgent;
					}

					if (currentError) {
						return Theme.values.urgent;
					}

					return Theme.values.textMuted;
				}

				text: {
					if (!Greetd.available) {
						return "Greetd is unavailable";
					}

					if (currentError) {
						return currentError;
					}

					return formatState(Greetd.state);
				}

				font {
					family: Theme.values.fontMonospace
					pixelSize: Theme.values.fontSize
				}
			}

			Text {
				text: {
					const session = Greeter.availableSessions[sessionSelector.index];

					if (!session)
						return "Unknown";

					return session.typeName.padEnd(9);
				}
				color: sessionSelector.textColor
				font: sessionSelector.font
			}

			Selector {
				id: sessionSelector

				preferredWidth: content.preferredWidth
				readOnly: content.readOnly

				values: Greeter.availableSessions.map(session => session.name)
				initValue: LastState.values.lastSession
			}

			Text {
				text: "Login"
				color: userSelector.textColor
				font: userSelector.font
			}

			Selector {
				id: userSelector

				preferredWidth: content.preferredWidth
				readOnly: content.readOnly

				values: Greeter.availableUsers.map(user => user.username)
				initValue: LastState.values.lastUsername
			}

			Text {
				text: "Password"
				color: passwordInput.textColor
				font: passwordInput.font
			}

			Password {
				id: passwordInput

				preferredWidth: content.preferredWidth
				readOnly: content.readOnly

				Component.onCompleted: {
					content.index = content.inputs.indexOf(passwordInput);
				}
			}
		}
	}
}
