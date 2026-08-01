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

    Instantiator {
        model: Quickshell.screens

        delegate: Scope {
            id: shell

            required property var index
            required property var modelData

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
