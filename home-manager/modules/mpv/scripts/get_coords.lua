mp.add_key_binding("h", "copy_pixel_coords", function()
	local mouse_pos = mp.get_property_native("mouse-pos")
	local osd_dims = mp.get_property_native("osd-dimensions")
	local video = mp.get_property_native("video-params")

	if not mouse_pos or not osd_dims or not video then
		return
	end

	local x_ratio = (mouse_pos.x - osd_dims.ml) / (osd_dims.w - osd_dims.ml - osd_dims.mr)
	local y_ratio = (mouse_pos.y - osd_dims.mt) / (osd_dims.h - osd_dims.mt - osd_dims.mb)

	local video_x = math.floor(x_ratio * video.w)
	local video_y = math.floor(y_ratio * video.h)

	local coords_text = string.format("%d %d", video_x, video_y)

	local native_success = mp.set_property("clipboard", coords_text)
	if not native_success then
		native_success = mp.set_property("clipboard/text", coords_text)
	end

	if not native_success then
		mp.command_native({
			name = "subprocess",
			args = { "wl-copy" },
			stdin_data = coords_text,
			playback_only = false,
		})
	end

	mp.osd_message("Copied: " .. coords_text, 3)
end)
