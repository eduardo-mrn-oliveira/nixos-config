{pkgs, ...}: {
	programs.fzf = {
		enable = true;
		enableBashIntegration = true;
	};

	home.packages = with pkgs; [
		fd
	];

	programs.alacritty.settings.env = {
		FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git --exclude result --exclude node_modules --exclude /nix/store";
		FZF_CTRL_T_COMMAND = "fd --type f --follow --exclude .git --exclude result --exclude node_modules --exclude /nix/store";
		FZF_ALT_C_COMMAND = "fd --type d --follow --exclude .git --exclude result --exclude node_modules --exclude /nix/store";

		FZF_CTRL_R_COMMAND = "";
	};
}
