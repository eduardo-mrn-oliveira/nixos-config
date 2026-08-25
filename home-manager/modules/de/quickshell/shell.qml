pragma ComponentBehavior: Bound

import QtQuick

import Quickshell

import "./taskbar"
import "./wallpaper"

import "./activate-linux"

import "./prompts"

ShellRoot {
	// Load singletons
	Component.onCompleted: {
		PromptManager;
	}

	Variants {
		model: Quickshell.screens

		delegate: Component {
			Scope {
				id: shell

				required property var modelData
				readonly property int index: Quickshell.screens.indexOf(modelData)

				Wallpaper {
					index: shell.index
					modelData: shell.modelData
				}

				Taskbar {
					screen: shell.modelData
				}

				ActivateLinux {
					screen: shell.modelData
				}
			}
		}
	}
}
