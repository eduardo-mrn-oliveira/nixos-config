{
	lib,
	pkgs,
	stdenv,
}:
stdenv.mkDerivation rec {
	pname = "umka";
	version = "1.5.5";

	src =
		pkgs.fetchurl {
			name = "umka-${version}.tar.gz";
			url = "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v${version}.tar.gz";
			sha256 = "sha256-t2c6RF7i/70WHInLB2RS2OBMTYQrq/bFvKlj5St1rf0=";
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
