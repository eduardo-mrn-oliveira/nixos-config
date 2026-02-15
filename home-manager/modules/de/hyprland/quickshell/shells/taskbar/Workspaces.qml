pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    readonly property int workspacesPerScreen: 9

    readonly property var focusedId: Hyprland.focusedWorkspace?.id ?? null

    readonly property var activeWorkspaces: Hyprland.workspaces.values.map(workspace => workspace.id)

    function getFor(screen) {
        const monitor = Hyprland.monitorFor(screen);

        if (!monitor) {
            return [];
        }

        const offset = monitor.id * workspacesPerScreen;

        const workspaces = [];

        for (let i = 1; i <= workspacesPerScreen; i++) {
            workspaces.push({
                id: offset + i,
                name: i
            });
        }

        return workspaces;
    }

    function isFocused(id) {
        return focusedId === id;
    }

    function isActive(id) {
        return activeWorkspaces.includes(id);
    }

    function switchTo(id) {
        Hyprland.dispatch("workspace " + id);
    }
}
