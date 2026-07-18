{
	services.keyd = {
		enable = true;
		keyboards = {
			default = {
				ids = ["*"];
				settings = {
					main = {
						kp0 = "overload(meta, kp0)";
						kpcomma = "overload(shift, kpcomma)";
						kpplus = "overload(shift, kpplus)";
					};
				};
			};
		};
	};
}
