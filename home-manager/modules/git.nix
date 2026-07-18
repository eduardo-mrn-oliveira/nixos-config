{
	programs.git = {
		enable = true;

		settings = {
			user = {
				name = "Eduardo Oliveira";
				email = "eduardo.mrn.oliveira@outlook.com";
			};

			init.defaultBranch = "main";
			core.editor = "zeditor --wait";

			credential.helper = "cache --timeout=3600";
		};
	};
}
