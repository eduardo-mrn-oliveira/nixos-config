pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [root.sink]
    }

    readonly property bool active: sink !== null && sink.audio !== undefined

    readonly property real volume: active ? (sink.audio.volume * 100) : NaN
    readonly property bool isMuted: active ? sink.audio.muted : false

    function increaseBy(amount: int) {
        if (active) {
            const volume = root.volume + amount;

            sink.audio.volume = Math.min(1, volume / 100);
        }
    }

    function decreaseBy(amount: int) {
        if (active) {
            const volume = root.volume - amount;

            sink.audio.volume = Math.max(0, volume / 100);
        }
    }

    function mute() {
        if (active) {
            sink.audio.muted = true;
        }
    }

    function unmute() {
        if (active) {
            sink.audio.muted = false;
        }
    }
}
