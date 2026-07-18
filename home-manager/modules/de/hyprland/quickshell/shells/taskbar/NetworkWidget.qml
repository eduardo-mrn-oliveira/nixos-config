import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

// TODO: Add ethernet icons (  WAN /  LAN )

RowLayout {
    id: root

    readonly property var connectedDevices: Networking.devices.values.filter(device => device.connected)

    visible: connectedDevices.length > 0

    spacing: 18

    Repeater {
        model: root.connectedDevices

        delegate: Text {
            required property var modelData

            property var network: modelData.networks?.values.find(network => network.connected)
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

            visible: network !== undefined

            text: `${icon}  ${networkName} (${Math.round(networkSignalStrength * 100)}%)`

            color: Theme.textPrimary

            font {
                family: Theme.fontMonospace
                pixelSize: Theme.fontSize
            }
        }
    }
}
