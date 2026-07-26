local settings = require("settings")

hl.exec_cmd("hyprctl output create headless REMOTE")

---@param workspace_id number
---@param monitor_name string
local function move_workspace_to_monitor(workspace_id, monitor_name)
	hl.dispatch(
		hl.dsp.workspace.move({
			workspace = tostring(workspace_id),
			monitor = monitor_name
		})
	)
end

---@param monitor_id number
---@param monitor_name string
local function assign_workspaces(monitor_id, monitor_name)
	local offset = monitor_id * settings.worskpaces_per_monitor

	for i = 1, settings.worskpaces_per_monitor do
		local workspace_id = offset + i

		move_workspace_to_monitor(workspace_id, monitor_name)
	end
end

do
	local monitors = hl.get_monitors()

	for _, monitor in pairs(monitors) do
		local offset = monitor.id * settings.worskpaces_per_monitor

		for i = 1, settings.worskpaces_per_monitor do
			local workspace_id = offset + i

			hl.workspace_rule({
				workspace = tostring(workspace_id),
				monitor = monitor.name,
				default = true
			})

			move_workspace_to_monitor(workspace_id, monitor.name)
		end
	end
end

hl.on("monitor.added", function(monitor)
	assign_workspaces(monitor.id, monitor.name)
end)

local scales = { "1.0", "1.25", "1.5" }
local monitor_scales = {
	["eDP-1"] = 3,
	["HDMI-A-1"] = 2,
	["REMOTE"] = 3
}

hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "0x0",
	scale = scales[monitor_scales["eDP-1"]]
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "auto-center-up",
	scale = scales[monitor_scales["HDMI-A-1"]]
})

hl.monitor({
	output = "REMOTE",
	mode = "preferred",
	position = "auto-center-down",
	scale = scales[monitor_scales["REMOTE"]],
	disabled = true
})

local function cycle_monitor_scale()
	local active_monitor = hl.get_active_monitor()

	if not active_monitor then return end

	local monitor_name = active_monitor.name
	local current_idx = monitor_scales[monitor_name] or 1

	current_idx = current_idx + 1
	if current_idx > #scales then current_idx = 1 end
	monitor_scales[monitor_name] = current_idx

	local new_scale = scales[current_idx]

	hl.monitor({
		output = monitor_name,
		scale = tostring(new_scale)
	})

	hl.notification.create({ text = "Monitor " .. monitor_name .. " set to " .. tostring(new_scale) .. "x", font_size = 18, timeout = 2000 })
end

local is_mirrored = false

local function toggle_mirror()
	is_mirrored = not is_mirrored

	if is_mirrored then
		hl.monitor({
			output = "HDMI-A-1",
			scale = "1.0",
			mirror = "eDP-1"
		})
		hl.notification.create({ text = "Mirroring HDMI-A-1 to eDP-1", font_size = 18, timeout = 2000 })
	else
		hl.monitor({
			output = "HDMI-A-1",
			scale = scales[monitor_scales["HDMI-A-1"]],
			mirror = ""
		})
		hl.notification.create({ text = "Extended Display Restored", font_size = 18, timeout = 2000 })
	end
end

-- TODO: Can this be improved?
-- Required to move workspaces back when disabling mirroring
hl.on("monitor.layout_changed", function()
	local monitors = hl.get_monitors()

	for _, monitor in pairs(monitors) do
		assign_workspaces(monitor.id, monitor.name)
	end
end)

local function toggle_remote_monitor()
	local monitor = hl.get_monitor("REMOTE")

	local is_disabled = monitor == nil

	is_disabled = not is_disabled

	hl.monitor({
		output = "REMOTE",
		disabled = is_disabled
	})

	if is_disabled then
		hl.notification.create({ text = "Disabled remote monitor", font_size = 18, timeout = 2000 })
	else
		hl.notification.create({ text = "Enabled remote monitor", font_size = 18, timeout = 2000 })
	end
end

hl.bind(settings.mod .. " + F10", cycle_monitor_scale)
hl.bind(settings.mod .. " + SHIFT + F10", toggle_mirror)

hl.bind(settings.mod .. " + F11", toggle_remote_monitor)
hl.bind(settings.mod .. " + SHIFT + F11", function()
	hl.dispatch(hl.dsp.exec_cmd([[
		if systemctl --user is-active --quiet sunshine; then
			hyprctl eval 'hl.notification.create({ text = "Stopping Sunshine", font_size = 18, timeout = 2000 })'

			if systemctl --user stop sunshine; then
				hyprctl eval 'hl.notification.create({ text = "Stopped Sunshine", font_size = 18, timeout = 2000 })'
			else
				hyprctl eval 'hl.notification.create({ text = "Failed to stop Sunshine", font_size = 18, timeout = 2000 })'
			fi
		else
			hyprctl eval 'hl.notification.create({ text = "Starting Sunshine", font_size = 18, timeout = 2000 })'

			if systemctl --user start sunshine; then
				hyprctl eval 'hl.notification.create({ text = "Started Sunshine", font_size = 18, timeout = 2000 })'
			else
				hyprctl eval 'hl.notification.create({ text = "Failed to start Sunshine", font_size = 18, timeout = 2000 })'
			fi
		fi
	]]))
end)
hl.bind(settings.mod .. " + ALT + F11", function()
	hl.dispatch(hl.dsp.exec_cmd([[
		if systemctl --user is-active --quiet sunshine; then
			hyprctl eval 'hl.notification.create({ text = "Sunshine is running", font_size = 18, timeout = 2000 })'
		else
			hyprctl eval 'hl.notification.create({ text = "Sunshine is stopped", font_size = 18, timeout = 2000 })'
		fi
	]]))
end)
