{
	homeStateVersion,
	config,
	pkgs,
	user,
	...
}: let
	all-ctl =
		import ./packages/all-ctl.nix {
			inherit pkgs;
		};

	sboard =
		import ./packages/sboard.nix {
			inherit pkgs;
		};
in {
	imports = [
		./modules/de/hyprland
		./modules/de/i3

		./modules/theming

		./modules/alacritty.nix
		./modules/atuin.nix
		./modules/bash.nix
		./modules/dunst.nix
		./modules/fzf.nix
		./modules/git.nix
		./modules/nix-index.nix
		./modules/zed.nix
		./modules/zen-browser.nix

		./modules/joplin.nix

		./modules/spotify.nix
		./modules/mpd.nix

		./modules/mpv.nix

		./modules/default-apps.nix

		./modules/direnv.nix
	];

	home = {
		username = user;
		homeDirectory = "/home/${user}";
		stateVersion = homeStateVersion;
	};

	nixpkgs.config.allowUnfree = true;

	home.packages = with pkgs; [
		# Utilities
		brightnessctl
		playerctl
		pavucontrol
		all-ctl
		sboard
	];

	xdg.userDirs = {
		enable = true;
		createDirectories = true;

		desktop = config.home.homeDirectory;
		download = "${config.home.homeDirectory}/Downloads";
		documents = "${config.home.homeDirectory}/Documents";
		videos = "${config.home.homeDirectory}/Videos";
		pictures = "${config.home.homeDirectory}/Images";
		music = "${config.home.homeDirectory}/Musics";

		publicShare = null;
		templates = null;
	};

	home.sessionVariables = {
		"XDG_DESKTOP_DIR" = config.xdg.userDirs.desktop;
		"XDG_DOWNLOAD_DIR" = config.xdg.userDirs.download;
		"XDG_DOCUMENTS_DIR" = config.xdg.userDirs.documents;
		"XDG_VIDEOS_DIR" = config.xdg.userDirs.videos;
		"XDG_PICTURES_DIR" = config.xdg.userDirs.pictures;
		"XDG_MUSIC_DIR" = config.xdg.userDirs.music;
	};
}
