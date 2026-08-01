pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string currentMessage: ""
    property string currentCallback: ""

    IpcHandler {
        target: "prompt"

        function ask(message: string, callback: string): void {
            if (promptLoader.active) {
                return;
            }

            root.currentMessage = message;
            root.currentCallback = callback;
            promptLoader.sourceComponent = askComponent;
            promptLoader.active = true;
        }

        function confirm(message: string, callback: string): void {
            if (promptLoader.active) {
                return;
            }

            root.currentMessage = message;
            root.currentCallback = callback;
            promptLoader.sourceComponent = confirmComponent;
            promptLoader.active = true;
        }
    }

    Component {
        id: askComponent

        AskPrompt {
            message: root.currentMessage
            callbackCommand: root.currentCallback
        }
    }

    Component {
        id: confirmComponent

        ConfirmPrompt {
            message: root.currentMessage
            callbackCommand: root.currentCallback
        }
    }

    Loader {
        id: promptLoader

        active: false
    }

    function closePrompt(): void {
        promptLoader.active = false;
        promptLoader.sourceComponent = undefined;
        root.currentMessage = "";
        root.currentCallback = "";
    }
}
