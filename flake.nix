{
	description = "My system configuration";

	inputs = {
		nixpkgs.follows = "nixpkgs-unstable";

		nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

		nixpkgs-rolling.url = "github:nixos/nixpkgs/nixos-unstable";

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
			url = "github:hyprwm/Hyprland";
			# inputs.nixpkgs.follows = "nixpkgs";
		};

		hyprtasking = {
			url = "github:eduardo-mrn-oliveira/hyprtasking";
			inputs.hyprland.follows = "hyprland";
		};

		quickshell = {
			url = "github:quickshell-mirror/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		qs-qml-types = {
			url = "gitlab:eduardo-mrn-oliveira/qs-qml-types";
			inputs.nixpkgs.follows = "quickshell/nixpkgs";
		};

		direnv-instant = {
			url = "github:Mic92/direnv-instant";
		};
	};

	outputs = {
		self,
		nixpkgs,
		nixpkgs-stable,
		nixpkgs-unstable,
		nixpkgs-rolling,
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
					inherit inputs system root stable unstable rolling custom stateVersion hostname user;
				};

				modules = [
					./hosts/${hostname}/hardware-configuration.nix
					./hosts/${hostname}/configuration.nix
				];
			};

		makeIso = {
			hostname,
			stateVersion,
		}:
			nixpkgs.lib.nixosSystem {
				inherit system;

				specialArgs = {
					inherit inputs system root stable unstable rolling custom stateVersion hostname user;
				};

				modules = [
					"${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

					./hosts/${hostname}/configuration.nix

					{
						home-manager.extraSpecialArgs = {
							inherit inputs system root stable unstable rolling custom homeStateVersion user;
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
					inherit inputs system root stable unstable rolling custom homeStateVersion user;
				};

				modules = [
					inputs.stylix.homeModules.stylix
					./home-manager
				];
			};

		packages.${system} =
			{
				inherit pkgs stable unstable rolling custom;
			}
			// (nixpkgs.lib.listToAttrs (
					map (host: {
							name = "${host.hostname}-ISO";
							value = self.nixosConfigurations."${host.hostname}-ISO".config.system.build.isoImage;
						})
					hosts
				));
	};
}
