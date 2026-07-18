{
	pkgs,
	custom,
	rolling,
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
		drawy

		# Apps
		discord
		rolling.vesktop
		libreoffice
		obs-studio
		mpv
		rolling.oculante
		spotify
		evince
		rustdesk-flutter

		# Code editors
		custom.sql-developer
		dbeaver-bin
		gedit
		bruno
		bruno-cli
		insomnia

		# Games
		prismlauncher
		heroic
		lutris
		custom.geforce-infinity
		pcsx2
		dolphin-emu

		# CLIs
		rolling.yt-dlp
		ffmpeg-full
		rolling.scrcpy
		p7zip
		ripgrep-all
		ncdu
		ngrok
		git

		# Other
		qbittorrent
		gparted
		appimage-run # Can become a part of a "Lutris" module

		# Magic
		libappindicator-gtk3
	];
}
