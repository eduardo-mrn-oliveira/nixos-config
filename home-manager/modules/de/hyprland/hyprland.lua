dofile(os.getenv("HOME") .. "/.config/hypr/plugins.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")

local main_monitor = "eDP-1"
-- local main_monitor = "HDMI-A-1"
local root_dir = "/home/vanisher/.nixos-config"
local mod = "SUPER"

local terminal = "alacritty"
local file_manager = "nautilus --new-window"
local menu = 'pkill wofi || wofi --show drun --prompt ""'
local editor = "zeditor"

local WORKSPACES_PER_SCREEN <const> = 9

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		enable_anr_dialog = false,
		force_default_wallpaper = 0,
		background_color = "rgb(000000)"
	},
	general = {
		gaps_in = 0,
		gaps_out = 0,
		layout = "hy3"
	},
	animations = {
		enabled = false
	},
	input = {
		kb_layout = "br",
		kb_variant = "abnt2",
		touchpad = {
			natural_scroll = true
		},
		follow_mouse = 2
	}
})

if hl.plugin.hyprtasking ~= nil then
	hl.config({
		plugin = {
			hyprtasking = {
				gap_size = 8,
				border_size = 2,
				bg_color = "0x00000000",
				select_button = "0x110",
				drag_button = "0x111"
			}
		}
	})
end

if hl.plugin.hy3 ~= nil then
	hl.config({
		plugin = {
			hy3 = {
				tab_first_window = true,
				tabs = {
					height = 26,
					padding = 0,
					radius = 0,
					border_width = 0,
					text_font = "monospace",
					text_height = 12,
					text_padding = 0,
				}
			}
		}
	})
end

local MONITOR_MODES <const> = {
	["eDP-1"] = {
		"1368x768@60",
		"1600x900@60",
		"1920x1080@60"
	},
	["HDMI-A-1"] = {
		"1368x768@120",
		"1600x900@120",
		"1920x1080@120"
	},
}

if main_monitor == "eDP-1" then
	hl.monitor({ output = "eDP-1", mode = MONITOR_MODES["eDP-1"][1], position = "0x0", scale = "1" })
	hl.monitor({ output = "HDMI-A-1", disabled = true })
else
	hl.monitor({ output = "eDP-1", disabled = true })
	hl.monitor({ output = "HDMI-A-1", mode = MONITOR_MODES["eDP-1"][2], position = "auto-up", scale = "1" })
end

local monitors = hl.get_monitors()

for _, monitor in pairs(monitors) do
	local offset = monitor.id * WORKSPACES_PER_SCREEN

	for i = 1, WORKSPACES_PER_SCREEN do
		local workspace_id = offset + i

		hl.workspace_rule({
			workspace = tostring(workspace_id),
			monitor = monitor.name,
			default = true
		})
	end
end

hl.window_rule({ match = { workspace = "w[g1]" }, border_size = 0 })
hl.window_rule({ match = { workspace = "w[t1]" }, border_size = 0 })

hl.env("NIXOS_OZONE_WL", "1")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm finalize WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE")
	hl.exec_cmd("hyprsunset")
end)

hl.bind(mod .. " + Insert", hl.dsp.submap("clean"))
hl.define_submap("clean", function()
	hl.bind(mod .. " + Insert", hl.dsp.submap("reset"))
end)

hl.bind(mod .. " + F10",
	function()
		hl.monitor({ output = main_monitor, mode = MONITOR_MODES[main_monitor][1], position = "auto-up", scale = "1" })
	end)
hl.bind(mod .. " + F11",
	function()
		hl.monitor({ output = main_monitor, mode = MONITOR_MODES[main_monitor][2], position = "auto-up", scale = "1" })
	end)
hl.bind(mod .. " + F12",
	function()
		hl.monitor({ output = main_monitor, mode = MONITOR_MODES[main_monitor][3], position = "auto-up", scale = "1" })
	end)

hl.bind(mod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(mod .. " + Apostrophe", hl.dsp.exec_cmd(terminal .. " --working-directory " .. root_dir))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd(editor .. " -n " .. root_dir))

if hl.plugin.hyprtasking ~= nil then
	hl.bind("Escape", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
	hl.bind(mod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
	hl.bind("CTRL + Tab", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
	hl.bind(mod .. " + KP_Enter", hl.dsp.exec_cmd("hyprctl dispatch hyprtasking:toggle cursor"))
end

hl.bind("ALT + Tab", hl.dsp.focus({ urgent_or_last = true }))

hl.bind(mod .. " + SHIFT + End", hl.dsp.exec_cmd("hyprshutdown --post-cmd 'poweroff'"))
hl.bind(mod .. " + SHIFT + Delete", hl.dsp.exec_cmd("hyprshutdown --post-cmd 'reboot'"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"))

hl.bind(mod .. " + P", hl.dsp.exec_cmd("hyprshot -zm region"))
hl.bind(mod .. " + ALT + P", hl.dsp.exec_cmd("hyprshot -zm region --cursor"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("pkill -9 hyprpicker"))
hl.bind(mod .. " + F5", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(mod .. " + W", hl.dsp.exec_cmd("qs ipc call taskbar toggle"))
hl.bind(mod .. " + SHIFT + space", hl.dsp.exec_cmd("qs ipc call wallpaper toggle"))
hl.bind(mod .. " + space", hl.dsp.exec_cmd("qs ipc call wallpaper toggleAnimation"))
hl.bind(mod .. " + ALT + space", hl.dsp.exec_cmd("qs ipc call wallpaper playPause"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("systemctl --user restart quickshell"))

hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))

if hl.plugin.hy3 ~= nil then
	hl.bind(mod .. " + SHIFT + left", hl.plugin.hy3.move_window("l"))
	hl.bind(mod .. " + SHIFT + right", hl.plugin.hy3.move_window("r"))
	hl.bind(mod .. " + SHIFT + up", hl.plugin.hy3.move_window("u"))
	hl.bind(mod .. " + SHIFT + down", hl.plugin.hy3.move_window("d"))
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

	local target_id = active_monitor_id * WORKSPACES_PER_SCREEN + workspace_id

	hl.dispatch(hl.dsp.focus({ workspace = tostring(target_id) }))
end

---@param workspace_id number
---@param silent boolean
local function move_to_workspace(workspace_id, silent)
	local active_monitor = hl.get_active_monitor()

	local active_monitor_id = active_monitor and active_monitor.id or 0

	local target_id = active_monitor_id * WORKSPACES_PER_SCREEN + workspace_id

	hl.dispatch(hl.dsp.window.move({ workspace = tostring(target_id), silent }))
end

for i = 1, WORKSPACES_PER_SCREEN do
	hl.bind(mod .. " + " .. i, function() switch_to_workspace(i) end)
	hl.bind(mod .. " + SHIFT + " .. i, function() move_to_workspace(i, true) end)

	local kp_key = kp_keys[i]
	hl.bind(mod .. " + " .. kp_key, function() switch_to_workspace(i) end)
	hl.bind(mod .. " + SHIFT + " .. kp_key, function() move_to_workspace(i, false) end)
end

hl.bind(mod .. " + A", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mod .. " + D", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "+1" }))

if hl.plugin.hy3 ~= nil then
	hl.bind(mod .. " + G", hl.plugin.hy3.make_group("tab"))
	hl.bind(mod .. " + SHIFT + G", hl.plugin.hy3.change_group("untab"))

	hl.bind(mod .. " + left", hl.plugin.hy3.move_focus("l"))
	hl.bind(mod .. " + right", hl.plugin.hy3.move_focus("r"))
	hl.bind(mod .. " + up", hl.plugin.hy3.move_focus("u"))
	hl.bind(mod .. " + down", hl.plugin.hy3.move_focus("d"))
	hl.bind(mod .. " + Z", hl.plugin.hy3.move_focus("l"))
	hl.bind(mod .. " + C", hl.plugin.hy3.move_focus("r"))
end

hl.bind(mod .. " + J", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ monitor = "r" }))
hl.bind(mod .. " + I", hl.dsp.focus({ monitor = "u" }))
hl.bind(mod .. " + K", hl.dsp.focus({ monitor = "d" }))

hl.bind(mod .. " + CTRL + J", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mod .. " + CTRL + L", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mod .. " + CTRL + I", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mod .. " + CTRL + K", hl.dsp.window.move({ monitor = "d" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("all-ctl volume +"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("all-ctl volume -"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("all-ctl volume toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("all-ctl mic toggle"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("all-ctl brightness +"))
hl.bind(mod .. " + period", hl.dsp.exec_cmd("all-ctl brightness +"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("all-ctl brightness -"))
hl.bind(mod .. " + comma", hl.dsp.exec_cmd("all-ctl brightness -"))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("all-ctl media next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("all-ctl media play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("all-ctl media play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("all-ctl media previous"))

hl.bind(mod .. " + M", hl.dsp.exec_cmd("hyprctl hyprsunset identity"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("hyprctl hyprsunset temperature 2500K"))

hl.bind(mod .. " + SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + SHIFT + mouse:273", hl.dsp.window.resize(), { mouse = true })
