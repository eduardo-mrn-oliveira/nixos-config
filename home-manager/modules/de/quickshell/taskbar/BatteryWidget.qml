import QtQuick
import Quickshell.Services.UPower

import "../config"

Text {
    color: Theme.values.textPrimary

    readonly property bool active: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery

    visible: active

    readonly property bool isCharging: !UPower.onBattery
    readonly property int percentage: Math.round(UPower.displayDevice.percentage * 100)

    readonly property string icon: {
        if (isCharging) {
            return "";
        }

        if (percentage < 20) {
            return "";
        }

        if (percentage < 50) {
            return "";
        }

        if (percentage < 75) {
            return "";
        }

        if (percentage < 90) {
            return "";
        }

        return "";
    }

    text: icon + " " + percentage + "%"

    font {
        family: Theme.values.fontMonospace
        pixelSize: Theme.values.fontSize
    }
}
