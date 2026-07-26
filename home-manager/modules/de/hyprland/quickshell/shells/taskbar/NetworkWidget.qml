import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

RowLayout {
    id: root

    readonly property var connectedDevices: Networking.devices.values.filter(device => device.connected)

    visible: connectedDevices.length > 0

    spacing: 18

    Repeater {
        model: root.connectedDevices

        delegate: Text {
            required property var modelData

            readonly property bool isWired: modelData.type === DeviceType.Wired
            readonly property bool isWifi: modelData.type === DeviceType.Wifi

            readonly property var network: isWired ? modelData.network : (modelData.networks?.values.find(n => n.connected) ?? null)

            readonly property string networkName: isWired ? "Wired" : (network?.name ?? "Unknown")
            readonly property double networkSignalStrength: network?.signalStrength ?? 0

            property string icon: {
                if (isWired) {
                    return "";
                }

                if (!network || networkSignalStrength === undefined) {
                    return "󰤫";
                }

                const icons = [["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"], ["󰤫", "󰤠", "󰤣", "󰤦", "󰤩"]];
                const iconGroup = network.connected ? 0 : 1;

                const level = Math.round(networkSignalStrength * 4);

                return icons[iconGroup][level];
            }

            visible: network !== undefined && network !== null

            text: {
                if (isWired) {
                    const speed = modelData.linkSpeed ? `${modelData.linkSpeed} Mbps` : "Connected";

                    return `${icon}  ${networkName} (${speed})`;
                }

                return `${icon}  ${networkName} (${Math.round(networkSignalStrength * 100)}%)`;
            }

            color: Theme.textPrimary

            font {
                family: Theme.fontMonospace
                pixelSize: Theme.fontSize
            }
        }
    }
}
