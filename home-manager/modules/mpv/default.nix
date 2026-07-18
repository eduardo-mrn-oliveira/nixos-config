{
	config,
	root,
	pkgs,
	...
}: {
	programs.mpv = {
		enable = true;

		scripts = with pkgs.mpvScripts; [
			uosc
			thumbfast
			mpris
			autoload
		];

		config = {
			# hwdec = "auto-safe";

			target-colorspace-hint = "no";

			screenshot-directory = "${config.xdg.userDirs.pictures}/Screenshots/mpv";

			screenshot-format = "png";
			screenshot-png-compression = 3;

			# screenshot-format = "jpg";
			# screenshot-jpeg-quality = 90;
		};
	};

	xdg.configFile."mpv/scripts".source = config.lib.file.mkOutOfStoreSymlink "${root}/home-manager/modules/mpv/scripts";
}
