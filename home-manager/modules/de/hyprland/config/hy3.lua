local colors = require("sys.colors")

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

	hl.config({
		plugin = {
			hy3 = {
				tabs = {
					colors = {
						active = "rgba(" .. colors.base0D .. "40)",
						active_border = "rgba(" .. colors.base0D .. "ee)",
						active_text = "rgba(" .. colors.base05 .. "ff)",
						active_alt_monitor = "rgba(" .. colors.base03 .. "40)",
						active_alt_monitor_border = "rgba(" .. colors.base03 .. "ee)",
						active_alt_monitor_text = "rgba(" .. colors.base05 .. "ff)",
						focused = "rgba(" .. colors.base02 .. "40)",
						focused_border = "rgba(" .. colors.base02 .. "ee)",
						focused_text = "rgba(" .. colors.base05 .. "ff)",
						inactive = "rgba(" .. colors.base01 .. "20)",
						inactive_border = "rgba(" .. colors.base01 .. "aa)",
						inactive_text = "rgba(" .. colors.base05 .. "ff)",
						urgent = "rgba(" .. colors.base08 .. "40)",
						urgent_border = "rgba(" .. colors.base08 .. "ee)",
						urgent_text = "rgba(" .. colors.base05 .. "ff)",
						locked = "rgba(" .. colors.base0A .. "40)",
						locked_border = "rgba(" .. colors.base0A .. "ee)",
						locked_text = "rgba(" .. colors.base05 .. "ff)"
					}
				}
			}
		}
	})
end
