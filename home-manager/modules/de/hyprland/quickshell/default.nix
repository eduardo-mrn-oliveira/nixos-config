{
	inputs,
	system,
	config,
	pkgs,
	lib,
	...
}: let
	quickshell =
		inputs.quickshell.packages.${system}.quickshell.withModules [
			pkgs.qt6.qtmultimedia
			inputs.qs-qml-types.packages.${system}.qs-qml-types
		];

	shellsRoot = ./shells;

	allFiles = lib.filesystem.listFilesRecursive shellsRoot;

	templateFiles = lib.filter (path: lib.hasSuffix ".nix" (toString path)) allFiles;

	mkTemplateEntry = path: let
		relPath = lib.removePrefix (toString shellsRoot + "/") (toString path);

		targetName = lib.removeSuffix ".nix" relPath + ".qml";

		content = import path {inherit config pkgs inputs system;};
	in {
		name = "quickshell/${targetName}";
		value = {text = content;};
	};

	templateConfigs = builtins.listToAttrs (map mkTemplateEntry templateFiles);

	templateTriggerPaths =
		map
		(name: config.xdg.configFile.${name}.source)
		(builtins.attrNames templateConfigs);
in {
	programs.quickshell = {
		enable = true;
		systemd.enable = true;

		package = quickshell;
	};

	xdg.configFile =
		templateConfigs
		// {
			"quickshell" = {
				source = shellsRoot;
				recursive = true;
			};
		};

	systemd.user.services.quickshell = {
		Unit.X-Restart-Triggers =
			templateTriggerPaths
			++ [
				"${config.xdg.configFile."quickshell".source}"
			];
	};
}
