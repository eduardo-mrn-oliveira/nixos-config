{
	inputs,
	config,
	system,
	root,
	pkgs,
	...
}: let
	hyprland =
		inputs.hyprland.packages.${system}.hyprland;

	hy3 = inputs.hy3.packages.${system}.hy3;
	#
	# hyprtasking =
	# 	inputs.hyprtasking.packages.${system}.hyprtasking;
in {
	imports = [
		./clipboard.nix

		./wofi.nix
	];

	home.packages = with pkgs; [
		hyprsunset
		hyprshot
		hyprshutdown
		wayvnc
	];

	home.sessionVariables = {
		"HYPRSHOT_DIR" = "${config.xdg.userDirs.pictures}/Screenshots";
	};

	wayland.windowManager.hyprland = {
		enable = true;
		systemd.enable = false;

		package = null;
		portalPackage = null;
	};

	xdg.configFile."hypr/sys/plugins.lua".text = ''
		hl.plugin.load("${hy3}/lib/libhy3.so")
	'';
	# hl.plugin.load("${hyprtasking}/lib/libhyprtasking.so")

	xdg.configFile."hypr/sys/colors.lua".text = ''
		return {
			base00 = "${config.lib.stylix.colors.base00}",
			base01 = "${config.lib.stylix.colors.base01}",
			base02 = "${config.lib.stylix.colors.base02}",
			base03 = "${config.lib.stylix.colors.base03}",
			base04 = "${config.lib.stylix.colors.base04}",
			base05 = "${config.lib.stylix.colors.base05}",
			base06 = "${config.lib.stylix.colors.base06}",
			base07 = "${config.lib.stylix.colors.base07}",
			base08 = "${config.lib.stylix.colors.base08}",
			base09 = "${config.lib.stylix.colors.base09}",
			base0A = "${config.lib.stylix.colors.base0A}",
			base0B = "${config.lib.stylix.colors.base0B}",
			base0C = "${config.lib.stylix.colors.base0C}",
			base0D = "${config.lib.stylix.colors.base0D}",
			base0E = "${config.lib.stylix.colors.base0E}",
			base0F = "${config.lib.stylix.colors.base0F}",
		}
	'';

	xdg.configFile."hypr/hyprland.lua".text = ''
		local config_dir = "${config.xdg.configHome}/hypr"
		package.path = package.path .. ";" .. config_dir .. "/config/?.lua;" .. config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua"

		require("sys.plugins")
		require("sys.colors")

		require("config")
	'';

	xdg.configFile."hypr/config".source =
		config.lib.file.mkOutOfStoreSymlink "${root}/home-manager/modules/de/hyprland/config";

	xdg.configFile."hypr/stubs".source = "${hyprland}/share/hypr/stubs";
}
