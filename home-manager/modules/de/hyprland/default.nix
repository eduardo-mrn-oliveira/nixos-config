{
	inputs,
	config,
	system,
	root,
	pkgs,
	...
}: let
	hy3 = inputs.hy3.packages.${system}.hy3;
	# hyprtasking =
	# 	inputs.hyprtasking.packages.${system}.hyprtasking;
in {
	imports = [
		./quickshell

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

	xdg.configFile."hypr/plugins.lua".text = ''
		hl.plugin.load("${hy3}/lib/libhy3.so")
	'';
	# hl.plugin.load("${hyprtasking}/lib/libhyprtasking.so")

	xdg.configFile."hypr/colors.lua".text = ''
		if hl.plugin.hy3 ~= nil then
			hl.config({
				plugin = {
					hy3 = {
						tabs = {
							colors = {
								active = "rgba(${config.lib.stylix.colors.base0D}40)",
								active_border = "rgba(${config.lib.stylix.colors.base0D}ee)",
								active_text = "rgba(${config.lib.stylix.colors.base05}ff)",
								active_alt_monitor = "rgba(${config.lib.stylix.colors.base03}40)",
								active_alt_monitor_border = "rgba(${config.lib.stylix.colors.base03}ee)",
								active_alt_monitor_text = "rgba(${config.lib.stylix.colors.base05}ff)",
								focused = "rgba(${config.lib.stylix.colors.base02}40)",
								focused_border = "rgba(${config.lib.stylix.colors.base02}ee)",
								focused_text = "rgba(${config.lib.stylix.colors.base05}ff)",
								inactive = "rgba(${config.lib.stylix.colors.base01}20)",
								inactive_border = "rgba(${config.lib.stylix.colors.base01}aa)",
								inactive_text = "rgba(${config.lib.stylix.colors.base05}ff)",
								urgent = "rgba(${config.lib.stylix.colors.base08}40)",
								urgent_border = "rgba(${config.lib.stylix.colors.base08}ee)",
								urgent_text = "rgba(${config.lib.stylix.colors.base05}ff)",
								locked = "rgba(${config.lib.stylix.colors.base0A}40)",
								locked_border = "rgba(${config.lib.stylix.colors.base0A}ee)",
								locked_text = "rgba(${config.lib.stylix.colors.base05}ff)"
							}
						}
					}
				}
			})
		end
	'';

	xdg.configFile."hypr/hyprland.lua".source =
		config.lib.file.mkOutOfStoreSymlink "${root}/home-manager/modules/de/hyprland/hyprland.lua";
}
