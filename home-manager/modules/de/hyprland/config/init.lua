require("hy3")
require("hyprtasking")

require("binds")

require("monitors")

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
	hl.exec_cmd("warp-cli disconnect")
end)
