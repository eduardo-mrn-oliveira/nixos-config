{root, ...}: {
	programs.nh = {
		enable = true;

		flake = root;

		clean = {
			enable = true;
			extraArgs = "--keep-since 12d --keep 5";
		};
	};
}
