{
	pkgs,
	custom,
	...
}: {
	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
		# Browsers
		brave

		# Editors
		gimp
		audacity
		kdePackages.kdenlive

		# Apps
		discord
		libreoffice
		obs-studio
		mpv
		oculante
		spotify
		sioyek
		rustdesk

		# Code editors
		custom.netdimas
		custom.sql-developer
		gedit

		# Games
		prismlauncher
		heroic
		custom.geforce-infinity
		pcsx2

		# CLIs
		yt-dlp
		ffmpeg-full
		scrcpy
		p7zip
		ripgrep-all
		ncdu

		# Other
		qbittorrent
		btop
		gparted

		# Magic
		libappindicator-gtk3
	];
}
