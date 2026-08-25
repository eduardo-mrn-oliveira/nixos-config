local colors = require("sys.colors")

if hl.plugin.hy3 ~= nil then
	hl.config({
		plugin = {
			hy3 = {
				tab_first_window = true,
				tabs = {
					height = 32,
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

	hl.config({
		plugin = {
			hy3 = {
				tabs = {
					colors = {
						focused = "rgba(" .. colors.base01 .. "ff)",
						focused_border = "rgba(" .. colors.base0D .. "ff)",
						focused_text = "rgba(" .. colors.base05 .. "ff)",

						active = "rgba(" .. colors.base00 .. "ff)",
						active_border = "rgba(" .. colors.base0C .. "ff)",
						active_text = "rgba(" .. colors.base05 .. "ff)",

						active_alt_monitor = "rgba(" .. colors.base00 .. "ff)",
						active_alt_monitor_border = "rgba(" .. colors.base0C .. "ff)",
						active_alt_monitor_text = "rgba(" .. colors.base05 .. "ff)",

						inactive = "rgba(" .. colors.base01 .. "ff)",
						inactive_border = "rgba(" .. colors.base02 .. "ff)",
						inactive_text = "rgba(" .. colors.base03 .. "ff)",

						urgent = "rgba(" .. colors.base08 .. "ff)",
						urgent_border = "rgba(" .. colors.base08 .. "ff)",
						urgent_text = "rgba(" .. colors.base05 .. "ff)",

						locked = "rgba(" .. colors.base0A .. "ff)",
						locked_border = "rgba(" .. colors.base0A .. "ff)",
						locked_text = "rgba(" .. colors.base05 .. "ff)"
					}
				}
			}
		}
	})
end
