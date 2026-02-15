{
	pkgs,
	user,
	...
}: {
	environment.systemPackages = with pkgs; [
		qemu_full
		quickemu

		(writeShellScriptBin "disable-kvm" ''
				#!/usr/bin/env bash
				echo "Disabling KVM modules..."
				sudo modprobe -r kvm_intel kvm_amd kvm
			'')

		(writeShellScriptBin "enable-kvm" ''
				#!/usr/bin/env bash
				echo "Re-enabling KVM modules..."
				if lscpu | grep -q Intel; then
					sudo modprobe kvm_intel
				else
					sudo modprobe kvm_amd
				fi
				sudo modprobe kvm
			'')

		waydroid-helper

		podman-compose
	];

	systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];

	# VirtManager

	users.extraGroups."libvirtd".members = [user];

	programs.virt-manager.enable = true;

	virtualisation.libvirtd = {
		enable = true;
	};

	environment.variables.LIBVIRT_DEFAULT_URI = "qemu:///system";

	# VirtualBox

	users.extraGroups."vboxusers".members = [user];

	virtualisation.virtualbox.host.enable = true;

	# Docker

	virtualisation.docker = {
		enable = true;

		rootless = {
			enable = true;
			setSocketVariable = true;
		};
	};

	# Waydroid

	virtualisation.waydroid = {
		enable = true;
		package = pkgs.waydroid-nftables;
	};

	# Podman

	virtualisation.containers.enable = true;

	virtualisation.podman = {
		enable = true;
		defaultNetwork.settings.dns_enabled = true;
	};
}
