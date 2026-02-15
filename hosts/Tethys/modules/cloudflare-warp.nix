{pkgs, ...}: let
	cloudflare-warp-headless =
		pkgs.cloudflare-warp.override {
			headless = true;
		};
in {
	services.cloudflare-warp = {
		enable = true;
		package = cloudflare-warp-headless;
	};
}
