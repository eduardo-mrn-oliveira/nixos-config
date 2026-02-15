import QtQuick
import Quickshell

Text {
    color: Theme.textPrimary

    readonly property string icon: {
        if (Audio.isMuted) {
            return "";
        }

        if (Audio.volume <= 50) {
            return "";
        }

        return " ";
    }

    readonly property string value: {
        if (isNaN(Audio.volume)) {
            return "?";
        }

        if (Audio.isMuted) {
            return "—";
        }

        return Math.round(Audio.volume) + "%";
    }

    text: icon + " " + value

    font {
        family: Theme.fontMonospace
        pixelSize: Theme.fontSize
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["pavucontrol"]);
            } else if (mouse.button === Qt.RightButton) {
                Audio.isMuted ? Audio.unmute() : Audio.mute();
            }
        }

        onWheel: wheel => {
            const amount = 5;

            if (wheel.angleDelta.y < 0) {
                Audio.decreaseBy(amount);
            } else if (wheel.angleDelta.y > 0) {
                Audio.increaseBy(amount);
            }
        }
    }
}
