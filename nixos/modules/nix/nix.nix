{
	inputs,
	root,
	...
}: {
	nix.settings.experimental-features = ["nix-command" "flakes"];

	nix.registry.os.to = {
		type = "path";
		path = root;
	};

	nix.registry.stable.flake = inputs.nixpkgs-stable;
	nix.registry.unstable.flake = inputs.nixpkgs-unstable;

	nix.settings.trusted-users = [
		"root"
		"@wheel"
	];

	nix.settings = {
		substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
	};
}
