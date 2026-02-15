{pkgs, ...}: {
	hardware.graphics = {
		enable = true;
		extraPackages = with pkgs; [
			intel-media-driver
			libvdpau-va-gl
			intel-compute-runtime-legacy1
		];
	};

	environment.sessionVariables = {
		LIBVA_DRIVER_NAME = "iHD";
	};
}
