{pkgs, ...}: {
	security.wrappers = {
		btop = {
			owner = "root";
			group = "root";
			capabilities = "cap_perfmon=ep";
			source = "${pkgs.btop}/bin/btop";
		};
	};
}
