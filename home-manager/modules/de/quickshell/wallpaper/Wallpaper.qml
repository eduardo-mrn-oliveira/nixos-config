import QtQuick
import QtMultimedia

import Quickshell
import Quickshell.Wayland

import Qs.yVanisher.Components

// qmllint disable uncreatable-type
PanelWindow {
    id: window

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Background
    focusable: false

    required property int index
    required property var modelData

    screen: modelData

    color: "black"

    AnimatedBackground {
        anchors.fill: parent

        visible: WallpaperManager.isWallpaperEnabled
        hasControlOverMedia: window.index === 0
        mediaController: WallpaperManager.mediaController
        isAnimated: WallpaperManager.shouldPlayVideo

        staticSource: Config.values.staticSource ? `file://${Config.values.staticSource}` : ""
        staticFillMode: WallpaperManager.fillModeLookup[Config.values.staticFillMode]?.static ?? Image.PreserveAspectFit

        animatedFillMode: WallpaperManager.fillModeLookup[Config.values.animatedFillMode]?.animated ?? VideoOutput.PreserveAspectFit
    }
}
