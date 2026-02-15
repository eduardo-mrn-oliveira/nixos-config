{pkgs, ...}: {
	fonts = {
		enableDefaultPackages = true;

		fontconfig.enable = true;

		packages = with pkgs; [
			dejavu_fonts
			jetbrains-mono
			noto-fonts
			noto-fonts-lgc-plus
			texlivePackages.hebrew-fonts
			noto-fonts-color-emoji
			font-awesome
			powerline-fonts
			powerline-symbols
			nerd-fonts.symbols-only
			nerd-fonts.fira-code
			corefonts
		];
	};
}
