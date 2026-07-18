{pkgs}:
pkgs.writeShellScriptBin "nix-del" ''
	set -euo pipefail

	for r in "$@"; do
		p="$(readlink -f "$r")"
		rm -f "$r"
		nix-store --delete "$p"
	done
''
