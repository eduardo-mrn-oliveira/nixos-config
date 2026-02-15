{pkgs}: let
	lib = pkgs.lib;
	root = ./.;

	discoverPackages =
		lib.listToAttrs (
			lib.map (
				dir: let
					p = root + "/${dir}";
				in {
					name = dir;
					value = pkgs.callPackage (p + "/package.nix") {};
				}
			) (
				lib.filter (
					dir: lib.pathExists (root + "/${dir}/package.nix")
				) (builtins.attrNames (builtins.readDir root))
			)
		);
in
	discoverPackages
