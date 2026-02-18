pragma Singleton

import QtQuick
import QtMultimedia
import Quickshell
import Qs.Custom

Singleton {
    id: root

    readonly property VideoOutputSplitter splitter: VideoOutputSplitter {
        mediaPlayer: player
    }

    // readonly property var hasFullscreen: Hyprland.focusedWorkspace?.hasFullscreen

    // onHasFullscreenChanged: {
    //     if (Config.isAnimated) {
    //         if (hasFullscreen) {
    //             pause();
    //         } else {
    //             play();
    //         }
    //     }
    // }

    MediaPlayer {
        id: player

        source: Config.wallpaper.video ?? ""
        loops: MediaPlayer.Infinite

        audioOutput: AudioOutput {
            muted: Config.isMuted
            volume: Config.volume / 100
        }
    }

    Component.onCompleted: {
        if (Config.isAnimated) {
            player.play();
        }
    }

    function play() {
        player.play();
    }

    function playPause() {
        if (player.playing) {
            player.pause();
        } else {
            player.play();
        }
    }

    function pause() {
        player.pause();
    }

    function stop() {
        player.stop();
    }
}
