pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property string time: {
        Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
