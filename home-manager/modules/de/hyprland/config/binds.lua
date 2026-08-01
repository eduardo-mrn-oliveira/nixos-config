local apps = require("apps")
local settings = require("settings")

---@param submap? string
local function switch_to_submap(submap)
	local actual = submap or "reset"
	local display = actual == "reset" and "Default" or actual

	hl.dispatch(hl.dsp.submap(actual))

	hl.notification.create({
		text = "Submap: " .. display,
		font_size = 18,
		timeout = 2000,
	})
end

hl.define_submap("Clean", function()
	hl.bind(settings.mod .. " + Insert", function() switch_to_submap() end)
end)
hl.bind(settings.mod .. " + Insert", function() switch_to_submap("Clean") end)

hl.bind(settings.mod .. " + R", hl.dsp.exec_cmd(apps.launcher))
hl.bind(settings.mod .. " + T", hl.dsp.exec_cmd(apps.terminal))
hl.bind(settings.mod .. " + E", hl.dsp.exec_cmd(apps.file_manager))
hl.bind(settings.mod .. " + Apostrophe",
	hl.dsp.exec_cmd(apps.terminal .. " --working-directory " .. settings.nixos_config_dir))
hl.bind(settings.mod .. " + Escape", hl.dsp.exec_cmd(apps.editor .. " -n " .. settings.nixos_config_dir))

if hl.plugin.hyprtasking ~= nil then
	hl.bind("Escape", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
	hl.bind(settings.mod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
	hl.bind("CTRL + Tab", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
	hl.bind(settings.mod .. " + KP_Enter", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
end

hl.bind("ALT + Tab", hl.dsp.focus({ last = true }))

hl.bind(settings.mod .. " + SHIFT + End", hl.dsp.exec_cmd(
	[[qs ipc call prompt confirm "Shut down?" "uwsm app -- hyprshutdown -t 'Shutting down...' --post-cmd 'poweroff'" || hyprshutdown -t 'Shutting down...' --post-cmd 'poweroff']]
))
hl.bind(settings.mod .. " + SHIFT + Delete", hl.dsp.exec_cmd(
	[[qs ipc call prompt confirm "Reboot?" "uwsm app -- hyprshutdown -t 'Rebooting...' --post-cmd 'reboot'" || hyprshutdown -t 'Rebooting...' --post-cmd 'reboot']]
))
hl.bind(settings.mod .. " + SHIFT + E", hl.dsp.exec_cmd(
	[[qs ipc call prompt confirm "Log out?" "uwsm app -- hyprshutdown -t 'Logging out...' --post-cmd 'uwsm stop'" || hyprshutdown -t 'Logging out...' --post-cmd 'uwsm stop']]
))

hl.bind(settings.mod .. " + P", hl.dsp.exec_cmd("hyprshot -zm region"))
hl.bind(settings.mod .. " + ALT + P", hl.dsp.exec_cmd("hyprshot -zm region --cursor"))
hl.bind(settings.mod .. " + Q", hl.dsp.window.close())
hl.bind(settings.mod .. " + SHIFT + P", hl.dsp.exec_cmd("pkill -9 hyprpicker"))
hl.bind(settings.mod .. " + F5", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(settings.mod .. " + W", hl.dsp.exec_cmd("qs ipc call taskbar toggle"))

hl.define_submap("Wallpaper", function()
	hl.bind("J", hl.dsp.exec_cmd("qs ipc call wallpaper toggle"))
	hl.bind("K", hl.dsp.exec_cmd("qs ipc call wallpaper toggleAnimation"))
	hl.bind("L", hl.dsp.exec_cmd("qs ipc call wallpaper playPause"))

	hl.bind("M", hl.dsp.exec_cmd("qs ipc call wallpaper muteUnmute"))
	hl.bind("comma", hl.dsp.exec_cmd("qs ipc call wallpaper volumeDown"))
	hl.bind("period", hl.dsp.exec_cmd("qs ipc call wallpaper volumeUp"))

	hl.bind(settings.mod .. " + space", function() switch_to_submap() end)
	hl.bind("escape", function() switch_to_submap() end)
end)

hl.bind(settings.mod .. " + space", function() switch_to_submap("Wallpaper") end)

hl.bind(settings.mod .. " + SHIFT + W", hl.dsp.exec_cmd("systemctl --user restart quickshell"))

hl.bind(settings.mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(settings.mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

if hl.plugin.hy3 ~= nil then
	hl.bind(settings.mod .. " + SHIFT + left", hl.plugin.hy3.move_window("l"))
	hl.bind(settings.mod .. " + SHIFT + right", hl.plugin.hy3.move_window("r"))
	hl.bind(settings.mod .. " + SHIFT + up", hl.plugin.hy3.move_window("u"))
	hl.bind(settings.mod .. " + SHIFT + down", hl.plugin.hy3.move_window("d"))
end

local kp_keys = {
	"KP_Home",
	"KP_Up",
	"KP_Prior",
	"KP_Left",
	"KP_Begin",
	"KP_Right",
	"KP_End",
	"KP_Down",
	"KP_Next"
}

---@param workspace_id number
local function switch_to_workspace(workspace_id)
	local active_monitor = hl.get_active_monitor()

	local active_monitor_id = active_monitor and active_monitor.id or 0

	local target_id = active_monitor_id * settings.worskpaces_per_monitor + workspace_id

	hl.dispatch(hl.dsp.focus({ workspace = tostring(target_id) }))
end

---@param workspace_id number
---@param silent boolean
local function move_to_workspace(workspace_id, silent)
	local active_monitor = hl.get_active_monitor()

	local active_monitor_id = active_monitor and active_monitor.id or 0

	local target_id = active_monitor_id * settings.worskpaces_per_monitor + workspace_id

	hl.dispatch(hl.dsp.window.move({ workspace = tostring(target_id), silent }))
end

for i = 1, settings.worskpaces_per_monitor do
	hl.bind(settings.mod .. " + " .. i, function() switch_to_workspace(i) end)
	hl.bind(settings.mod .. " + SHIFT + " .. i, function() move_to_workspace(i, true) end)

	local kp_key = kp_keys[i]
	hl.bind(settings.mod .. " + " .. kp_key, function() switch_to_workspace(i) end)
	hl.bind(settings.mod .. " + SHIFT + " .. kp_key, function() move_to_workspace(i, false) end)
end

hl.bind(settings.mod .. " + A", hl.dsp.focus({ workspace = "-1" }))
hl.bind(settings.mod .. " + D", hl.dsp.focus({ workspace = "+1" }))
hl.bind(settings.mod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(settings.mod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "+1" }))

hl.bind(settings.mod .. "+ 0", hl.dsp.exec_cmd(
	[[qs ipc call prompt ask 'Switch to workspace:' 'hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = \"$1\" }))"']]
))

if hl.plugin.hy3 ~= nil then
	hl.bind(settings.mod .. " + G", hl.plugin.hy3.make_group("tab"))
	hl.bind(settings.mod .. " + SHIFT + G", hl.plugin.hy3.change_group("untab"))

	hl.bind(settings.mod .. " + left", hl.plugin.hy3.move_focus("l"))
	hl.bind(settings.mod .. " + right", hl.plugin.hy3.move_focus("r"))
	hl.bind(settings.mod .. " + up", hl.plugin.hy3.move_focus("u"))
	hl.bind(settings.mod .. " + down", hl.plugin.hy3.move_focus("d"))

	hl.bind(settings.mod .. " + Z", hl.plugin.hy3.move_focus("l"))
	hl.bind(settings.mod .. " + C", hl.plugin.hy3.move_focus("r"))
end

hl.bind(settings.mod .. " + J", hl.dsp.focus({ monitor = "l" }))
hl.bind(settings.mod .. " + L", hl.dsp.focus({ monitor = "r" }))
hl.bind(settings.mod .. " + I", hl.dsp.focus({ monitor = "u" }))
hl.bind(settings.mod .. " + K", hl.dsp.focus({ monitor = "d" }))

hl.bind(settings.mod .. " + SHIFT + J", hl.dsp.window.move({ monitor = "l" }))
hl.bind(settings.mod .. " + SHIFT + L", hl.dsp.window.move({ monitor = "r" }))
hl.bind(settings.mod .. " + SHIFT + I", hl.dsp.window.move({ monitor = "u" }))
hl.bind(settings.mod .. " + SHIFT + K", hl.dsp.window.move({ monitor = "d" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("all-ctl volume +"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("all-ctl volume -"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("all-ctl volume toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("all-ctl mic toggle"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("all-ctl brightness +"))
hl.bind(settings.mod .. " + period", hl.dsp.exec_cmd("all-ctl brightness +"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("all-ctl brightness -"))
hl.bind(settings.mod .. " + comma", hl.dsp.exec_cmd("all-ctl brightness -"))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("all-ctl media next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("all-ctl media play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("all-ctl media play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("all-ctl media previous"))

hl.bind(settings.mod .. " + XF86AudioNext", hl.dsp.exec_cmd("rmpc next"))
hl.bind(settings.mod .. " + XF86AudioPause", hl.dsp.exec_cmd("rmpc togglepause"))
hl.bind(settings.mod .. " + XF86AudioPlay", hl.dsp.exec_cmd("rmpc togglepause"))
hl.bind(settings.mod .. " + XF86AudioPrev", hl.dsp.exec_cmd("rmpc prev"))

hl.bind(settings.mod .. " + M", hl.dsp.exec_cmd("hyprctl hyprsunset identity"))
hl.bind(settings.mod .. " + N", hl.dsp.exec_cmd("hyprctl hyprsunset temperature 2500K"))

hl.bind(settings.mod .. " + SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(settings.mod .. " + SHIFT + mouse:273", hl.dsp.window.resize(), { mouse = true })
