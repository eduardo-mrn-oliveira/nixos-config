{pkgs, ...}: let
	wallpaper = {
		source = {
			image = ./wallpapers/white-eyes.jpg;
			video = ./wallpapers/white-eyes.mp4;
		};

		settings = {
			brightness = "-30";
			contrast = "0";
		};

		filterHald =
			pkgs.runCommand "filter-hald.png" {
				nativeBuildInputs = [pkgs.imagemagick];
			} ''
				magick hald:8 \
					-brightness-contrast ${wallpaper.settings.brightness},${wallpaper.settings.contrast} \
					$out
			'';

		video =
			pkgs.runCommand "background.mp4" {
				nativeBuildInputs = [pkgs.ffmpeg-full];
			} ''
				ffmpeg -y -i "${wallpaper.source.video}" -i "${wallpaper.filterHald}" \
					-filter_complex "[0:v][1:v]haldclut" \
					-pix_fmt yuv420p \
					-c:v libx264 \
					-preset fast \
					-crf 18 \
					-an \
					$out
			'';

		image =
			pkgs.runCommand "background.png" {
				nativeBuildInputs = [pkgs.imagemagick];
			} ''
				magick "${wallpaper.source.image}" \
					-brightness-contrast ${wallpaper.settings.brightness},${wallpaper.settings.contrast} \
					$out
			'';
	};
in {
	imports = [
		./options.nix
	];

	theming.wallpaper.image = ./wallpapers/reze.jpg;
	theming.wallpaper.video = ./wallpapers/reze.mp4;

	# theming.wallpaper.image = wallpaper.image;
	# theming.wallpaper.video = wallpaper.video;

	home.packages = [pkgs.base16-schemes];

	stylix = {
		enable = true;
		autoEnable = true;

		polarity = "dark";

		base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

		targets = {
			qt.enable = true;

			zed.enable = false;
			zen-browser.enable = false;
		};

		cursor = {
			name = "DMZ-Black";
			size = 24;
			package = pkgs.vanilla-dmz;
		};

		icons = {
			enable = true;
			package = pkgs.papirus-icon-theme;
			dark = "Papirus-Dark";
			light = "Papirus-Light";
		};

		fonts = {
			monospace = {
				name = "FiraCode Nerd Font";
				package = pkgs.nerd-fonts.fira-code;
			};
			sansSerif = {
				name = "Noto Sans";
				package = pkgs.noto-fonts;
			};
			serif = {
				name = "Noto Serif";
				package = pkgs.noto-fonts;
			};
			emoji = {
				name = "Noto Color Emoji";
				package = pkgs.noto-fonts-color-emoji;
			};

			sizes = {
				terminal = 18;
				desktop = 16;
				applications = 16;
				popups = 14;
			};
		};
	};
}
