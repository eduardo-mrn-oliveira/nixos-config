{
	stdenv,
	pkgs,
	lib,
}: let
	system = "x86_64-linux";

	nixpkgs-oraclejdk8 =
		import (fetchTarball {
				name = "nixpkgs-oraclejdk8";
				url = "https://github.com/NixOS/nixpkgs/archive/c6b5632d7066510ec7a2cb0d24b1b24dac94cf82.tar.gz";
				sha256 = "sha256:0sciafjzk8cbs8lgk3xc5yx7dn91h74ihsylkwlk5bcpx6i736sf";
			}) {
			inherit system;
			config.allowUnfree = true;
		};
in
	stdenv.mkDerivation {
		pname = "netdimas";
		version = "8.2";

		src =
			pkgs.requireFile rec {
				name = "jdk-8u111-nb-8_2-linux-x64.sh";
				sha256 = "sha256-FaQZlhWO125Ah1Ls7WaV181HS+w4O2PO7KgHLqj6MaA=";
				message =
					"You need to download '${name}' manually\n"
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
					name = "netdimas";
					desktopName = "NetDimas";
					genericName = "NetBeans 8.2";
					comment = "NetDimas (NetBeans 8.2 with Oracle JDK 8)";
					exec = "netdimas %F";
					icon = "netdimas";
					terminal = false;
					categories = ["Development" "IDE" "Java"];
				})
		];

		nativeBuildInputs = with pkgs; [
			makeWrapper
			gnused
			coreutils
			nixpkgs-oraclejdk8.oraclejdk8
		];

		buildInputs = [
			nixpkgs-oraclejdk8.oraclejdk8
		];

		dontUnpack = true;

		buildPhase = ''
			set -e

			local block_size=1024

			local script_size=$(( 110 * block_size ))

			local test_jvm_size=$(( (658 + block_size - 1) / block_size * block_size ))
			local jre_size=$(( (46509286 + block_size - 1) / block_size * block_size ))

			local installer_size=249676438
			local installer_offset=$(($script_size + $test_jvm_size + $jre_size))

			echo "Extracting the NetBeans installer..."

			local installer_path="$PWD/installer.jar"

			dd if=$src of=$installer_path bs=16M skip=$installer_offset count=$installer_size iflag=skip_bytes,count_bytes

			echo "Verifying MD5 for the NetBeans installer..."

			local installer_md5="0f9a87cc8c2a6a10fe157ddb0e4e7021"

			local extracted_md5=$(md5sum $installer_path | cut -d ' ' -f 1)

			if [ "$extracted_md5" != "$installer_md5" ]; then
			    echo "Error: MD5 mismatch for installer. Expected: $installer_md5, Got: $extracted_md5"
			    exit 1
			fi

			echo "Running the NetBeans installer..."

			java -jar $installer_path --silent > /dev/null
		'';

		installPhase = ''
			set -e

			echo "Copying installation..."

			local netbeans_dir="netbeans-8.2"
			local nbi_dir=".nbi"

			mkdir -p $out/$netbeans_dir $out/$nbi_dir

			cp -a $PWD/$netbeans_dir/. $out/$netbeans_dir
			cp -a $PWD/$nbi_dir/. $out/$nbi_dir

			echo "Patching configuration files..."

			local jdk_home="${nixpkgs-oraclejdk8.oraclejdk}"
			local netbeans_path="$out/$netbeans_dir"

			sed -i "s#netbeans_jdkhome=\".*\"#netbeans_jdkhome=\"$jdk_home\"#" $netbeans_path/etc/netbeans.conf

			local nbi_path="$out/$nbi_dir"

			find $nbi_path -type f -exec sed -i "s#$PWD/$jdk_dir#$jdk_home#g" {} +
			find $nbi_path -type f -exec sed -i "s#$PWD/$netbeans_dir#$out/$netbeans_dir#g" {} +

			echo "Creating wrapper..."

			mkdir -p $out/bin
			makeWrapper $out/$netbeans_dir/bin/netbeans $out/bin/netdimas \
				--run "if [ ! -d \"\$HOME/.nbi\" ]; then (cd $out && tar cf - .nbi) | (cd \"\$HOME\" && tar xf -); fi"

			echo "Saving icon..."

			mkdir -p $out/share/icons/hicolor/256x256/apps
			cp $netbeans_path/nb/netbeans.png $out/share/icons/hicolor/256x256/apps/netdimas.png
		'';

		meta = with lib; {
			license = licenses.unfree;
			platforms = [system];
		};
	}
