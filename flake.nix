{
	description = "My system configuration";

	inputs = {
		nixpkgs.follows = "nixpkgs-unstable";

		nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

		nixpkgs-unstable.url = "github:nixos/nixpkgs/bb01c8c8fdd2ad82261964bf3aeb6bb3e6dcc12e";

		nixpkgs-rolling.url = "github:nixos/nixpkgs/nixos-unstable";

		nixpkgs-sys.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zen-browser = {
			url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		hyprland = {
			url = "github:hyprwm/Hyprland/v0.56.0";
		};

		hyprtasking = {
			url = "github:eduardo-mrn-oliveira/hyprtasking";
			inputs.hyprland.follows = "hyprland";
		};

		hy3 = {
			url = "github:outfoxxed/hy3/hl0.56.0.1";
			inputs.hyprland.follows = "hyprland";
		};

		quickshell = {
			url = "github:eduardo-moliveira/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		qs-qml-types = {
			url = "gitlab:eduardo-mrn-oliveira/qs-qml-types";
			inputs.nixpkgs.follows = "quickshell/nixpkgs";
		};

		direnv-instant = {
			url = "github:Mic92/direnv-instant";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		rust-overlay = {
			url = "github:oxalica/rust-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {
		self,
		nixpkgs,
		nixpkgs-stable,
		nixpkgs-unstable,
		nixpkgs-rolling,
		nixpkgs-sys,
		home-manager,
		...
	} @ inputs: let
		system = "x86_64-linux";
		homeStateVersion = "26.05";

		root = "/home/${user}/.nixos-config";

		pkgs =
			import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};

		stable =
			nixpkgs-stable.legacyPackages.${system};

		unstable =
			nixpkgs-unstable.legacyPackages.${system};

		rolling =
			nixpkgs-rolling.legacyPackages.${system};

		sys =
			nixpkgs-sys.legacyPackages.${system};

		custom =
			import ./nixpkgs-custom {
				inherit pkgs;
			};

		user = "vanisher";
		hosts = [
			{
				hostname = "Tethys";
				stateVersion = "26.05";
			}
		];

		makeSystem = {
			hostname,
			stateVersion,
		}:
			nixpkgs.lib.nixosSystem {
				inherit system;

				specialArgs = {
					inherit inputs system root stable unstable rolling sys custom stateVersion hostname user;
				};

				modules = [
					./hosts/${hostname}/hardware-configuration.nix
					./hosts/${hostname}/configuration.nix
				];
			};

		makeIso = {
			# TODO: Can be merged into 'makeSystem" by using 'image.modules'
			hostname,
			stateVersion,
		}:
			nixpkgs.lib.nixosSystem {
				inherit system;

				specialArgs = {
					inherit inputs system root stable unstable rolling sys custom stateVersion hostname user;
				};

				modules = [
					"${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

					./hosts/${hostname}/configuration.nix

					{
						home-manager.extraSpecialArgs = {
							inherit inputs system root stable unstable rolling sys custom homeStateVersion user;
						};

						home-manager.users.${user} = {
							imports = [
								inputs.stylix.homeModules.stylix
								./home-manager
							];
						};
					}

					./iso-config.nix
				];
			};
	in {
		nixosConfigurations =
			nixpkgs.lib.foldl' (configs: host:
					configs
					// {
						"${host.hostname}" =
							makeSystem {
								inherit (host) hostname stateVersion;
							};

						"${host.hostname}-ISO" =
							makeIso {
								inherit (host) hostname stateVersion;
							};
					}) {}
			hosts;

		homeConfigurations.${user} =
			home-manager.lib.homeManagerConfiguration {
				inherit pkgs;

				extraSpecialArgs = {
					inherit inputs system root stable unstable rolling sys custom homeStateVersion user;
				};

				modules = [
					inputs.stylix.homeModules.stylix
					./home-manager
				];
			};

		packages.${system} =
			{
				inherit pkgs stable unstable rolling sys custom;
			}
			// (nixpkgs.lib.listToAttrs (
					nixpkgs.lib.concatMap (host: [
							{
								name = "${host.hostname}-ISO";
								value = self.nixosConfigurations."${host.hostname}-ISO".config.system.build.isoImage;
							}
						])
					hosts
				));
	};
}
