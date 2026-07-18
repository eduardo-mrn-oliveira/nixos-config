pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

FileView {
    id: file

    path: Quickshell.env("YGREETER_THEME") ?? ""

    watchChanges: true
    onFileChanged: reload()

    blockLoading: true

    property alias values: json

    // qmllint disable unresolved-type
    JsonAdapter {
        id: json

        property color backgroundPrimary: "#0b0e14"
        property color backgroundSecondary: "#131721"

        property color highlight: "#202229"

        property color textPrimary: "#e6e1cf"
        property color textMuted: "#3e4b59"

        property color accent: "#59c2ff"
        property color urgent: "#f07178"
        property color warning: "#ffb454"
        property color success: "#aad94c"

        property string fontMonospace: "FiraCode Nerd Font"

        property int fontSize: 20
    }
}
