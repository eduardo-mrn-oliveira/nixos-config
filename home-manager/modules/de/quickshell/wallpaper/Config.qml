pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

FileView {
    path: Quickshell.env("YVANISHER_QS_WALLPAPER_CONFIG") ?? Qt.resolvedUrl("config.json")

    watchChanges: true
    onFileChanged: reload()

    blockLoading: true

    property alias values: json

    // qmllint disable unresolved-type
    JsonAdapter {
        id: json

        property string staticSource
        property string staticFillMode

        property string animatedSource
        property string animatedFillMode

        property bool startEnabled: true
        property bool startAnimated: false

        property bool isMuted: true
        property int volume: 100
    }
}
