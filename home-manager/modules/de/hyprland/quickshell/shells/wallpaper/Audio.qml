pragma Singleton

import QtQuick
import QtMultimedia
import Quickshell

Singleton {
    id: root

    readonly property MediaPlayer player: MediaPlayer {
        source: Config.wallpaper.video ?? ""
        loops: MediaPlayer.Infinite

        audioOutput: AudioOutput {
            muted: Config.isMuted
            volume: 1.0
        }
    }

    function play() {
        if (Config.isMuted || player.playing) {
            return;
        }

        player.play();
    }

    function stop() {
        if (!player.playing) {
            return;
        }

        player.stop();
    }
}
