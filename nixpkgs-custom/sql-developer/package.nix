{
	lib,
	pkgs,
	stdenv,
}:
stdenv.mkDerivation rec {
	pname = "sql-developer";
	version = "24.3.1.347.1826";

	src =
		pkgs.requireFile rec {
			name = "sqldeveloper-${version}-no-jre.zip";
			url = "https://www.oracle.com/database/sqldeveloper/technologies/download";
			sha256 = "sha256-M5DvWJcvHyVQd8SeZrFxuGZHc7sW43Vwp8oWrMWvuMs=";
			message =
				"You need to download '${name}' manually.\n"
				+ "Please go to '${url}' to download it yourself,\n"
				+ "and place it in the Nix store by running:\n"
				+ "\n"
				+ "\tnix-store --add-fixed sha256 ./${name}\n"
				+ "\n"
				+ "or by using `nix-prefetch-url`:\n"
				+ "\n"
				+ "\tnix-prefetch-url file://$PWD/${name}\n";
		};

	desktopItems = [
		(pkgs.makeDesktopItem {
				name = "sql-developer";
				desktopName = "SQL Developer";
				exec = "sql-developer %F";
				terminal = false;
				categories = ["Development" "IDE"];
			})
	];

	nativeBuildInputs = with pkgs; [
		unzip
		makeWrapper
	];

	buildInputs = with pkgs; [
		jdk17
	];

	installPhase = ''
		mkdir -p $out/bin

		mkdir -p $out/sql-developer
		cp -r ./* $out/sql-developer

		makeWrapper $out/sql-developer/sqldeveloper/bin/sqldeveloper $out/bin/sql-developer
	'';

	meta = with lib; {
		license = licenses.unfree;
		platforms = ["x86_64-linux"];
	};
}
