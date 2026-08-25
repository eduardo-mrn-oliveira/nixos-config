{
	root,
	rolling,
	...
}: {
	programs.nh = {
		enable = true;

		package = rolling.nh;

		flake = root;

		clean = {
			enable = true;
			extraArgs = "--keep-since 12d --keep 5";
		};
	};
}
