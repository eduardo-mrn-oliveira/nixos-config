local settings = require("settings")

-- TODO: Something better
if settings.main_monitor == "eDP-1" then
	hl.monitor({ output = "eDP-1", mode = settings.monitor_modes["eDP-1"][1], position = "0x0", scale = "1" })
	hl.monitor({ output = "HDMI-A-1", disabled = true })
elseif settings.main_monitor == "HDMI-1-A" then
	hl.monitor({ output = "eDP-1", disabled = true })
	hl.monitor({ output = "HDMI-A-1", mode = settings.monitor_modes["HDMI-A-1"][2], position = "auto-up", scale = "1" })
else
	hl.monitor({ output = "eDP-1", mode = settings.monitor_modes["eDP-1"][1], position = "0x0", scale = "1" })
	hl.monitor({ output = "HDMI-A-1", mode = settings.monitor_modes["HDMI-A-1"][2], position = "auto-up", scale = "1" })
end

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
	end
end
