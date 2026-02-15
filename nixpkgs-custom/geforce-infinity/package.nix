{
	lib,
	pkgs,
	appimageTools,
}: let
	version = "1.2.1";

	desktopFile =
		pkgs.fetchurl {
			url = "https://raw.githubusercontent.com/AstralVixen/GeForce-Infinity/${version}/com.github.astralvixen.geforce-infinity.desktop";
			hash = "sha256-3CCiVU53zvfHvShFHo2aZ2CqKAK0FdP7uTWyLCXog+Q=";
		};

	licenseFile =
		pkgs.fetchurl {
			url = "https://raw.githubusercontent.com/AstralVixen/GeForce-Infinity/${version}/LICENSE";
			hash = "sha256-ZptGoxNCqZVJGX7Zf6xCAAu/4XgRSy1oQ6oI9pArEaE=";
		};
in
	appimageTools.wrapType2 rec {
		pname = "geforce-infinity";
		inherit version;

		src =
			pkgs.fetchurl {
				url = "https://github.com/AstralVixen/GeForce-Infinity/releases/download/${version}/GeForceInfinity-linux-${version}-x86_64.AppImage";
				hash = "sha256-y2ydfictA2ssrAQM6DX6G2gcAqHhG7J6yfxph4diXBQ=";
			};

		extraPkgs = pkgs:
			with pkgs; [
				libsecret
				libappindicator
				libnotify
			];

		extraInstallCommands = ''
			mkdir -p $out/share/applications
			cp ${desktopFile} $out/share/applications/${pname}.desktop

			substituteInPlace $out/share/applications/${pname}.desktop \
			--replace-fail "Exec=/opt/geforce-infinity/geforce-infinity" "Exec=${pname}"

			mkdir -p $out/share/doc/${pname}
			cp ${licenseFile} $out/share/doc/${pname}
		'';

		meta = with lib; {
			homepage = "https://geforce-infinity.xyz";
			description = "A next-gen Linux client for GeForce NOW";
			license = licenses.mit;
			platforms = ["x86_64-linux"];
		};
	}
