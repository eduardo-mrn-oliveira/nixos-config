{
	lib,
	pkgs,
	stdenv,
}:
stdenv.mkDerivation rec {
	pname = "umka";
	version = "1.5.6";

	src =
		pkgs.fetchFromGitHub {
			owner = "vtereshkov";
			repo = "umka-lang";
			rev = "v${version}";
			hash = "sha256-wEgybH1L69iOGuwctaeQSigB4+LeTEBtpPWeqR5aT68=";
		};

	makeFlags = ["PREFIX=${placeholder "out"}"];

	postInstall = ''
		mkdir -p $out/share/doc/${pname}

		cp LICENSE $out/share/doc/${pname}
	'';

	meta = with lib; {
		homepage = "https://github.com/vtereshkov/umka-lang";
		description = "A statically typed embeddable scripting language";
		license = licenses.bsd2;
		platforms = platforms.all;
	};
}
