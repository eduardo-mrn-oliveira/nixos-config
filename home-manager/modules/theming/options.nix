{lib, ...}:
with lib; {
	options.theming.wallpaper = {
		startAnimated =
			mkOption {
				type = types.bool;
				default = false;
				description = "Whether the wallpaper should start animated or not.";
			};

		image =
			mkOption {
				type = types.nullOr types.path;
				default = null;
				description = "Path to the wallpaper image.";
			};

		video =
			mkOption {
				type = types.nullOr types.path;
				default = null;
				description = "Path to the wallpaper video.";
			};

		isMuted =
			mkOption {
				type = types.bool;
				default = true;
				description = "Whether the wallpaper video should be muted or not.";
			};
	};
}
