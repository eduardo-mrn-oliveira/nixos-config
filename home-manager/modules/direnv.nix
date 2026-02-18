{inputs, ...}: {
	imports = [inputs.direnv-instant.homeModules.direnv-instant];

	programs.direnv = {
		enable = true;
		enableBashIntegration = false;
		nix-direnv.enable = true;
	};

	programs.direnv-instant.enable = true;
}
