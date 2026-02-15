import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

// Ethernet:  WAN /  LAN

RowLayout {
    Repeater {
        model: Networking.devices

        delegate: Text {
            required property var modelData

            property var network: modelData.networks?.values[0]
            property string networkName: network?.name ?? "Unknown"
            property double networkSignalStrength: network?.signalStrength ?? 0

            property string icon: {
                if (!network || !network.signalStrength) {
                    return "󰤫";
                }

                const icons = [["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"], ["󰤫", "󰤠", "󰤣", "󰤦", "󰤩",]];
                const iconGroup = network.connected ? 0 : 1;

                const level = Math.round(network.signalStrength * 4);

                return icons[iconGroup][level];
            }

            text: `${icon}  ${networkName} (${Math.round(networkSignalStrength * 100)}%)`

            color: Theme.textPrimary

            font {
                family: Theme.fontMonospace
                pixelSize: Theme.fontSize
            }
        }
    }
}
