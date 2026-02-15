{pkgs, ...}: let
	lySetup =
		pkgs.writeShellScript "ly-setup" ''
			if command -v systemctl >/dev/null 2>&1; then
			    systemctl --user stop graphical-session.target graphical-session-pre.target nixos-fake-graphical-session.target xdg-desktop-portal.service xdg-document-portal.service xdg-permission-store.service
			    systemctl --user unset-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP XDG_SESSION_ID
			fi

			if [ -f /etc/profile ]; then . /etc/profile; fi
			if [ -f "$HOME/.profile" ]; then . "$HOME/.profile"; fi

			case "$@" in
			    *uwsm*)
			        exec "$@"
			        ;;
			esac

			if [ -f "$HOME/.xprofile" ]; then . "$HOME/.xprofile"; fi

			if command -v xrdb >/dev/null 2>&1; then
			    xrdb -merge /etc/X11/Xresources 2>/dev/null
			    [ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
			fi

			if command -v systemctl >/dev/null 2>&1; then
			    systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY XDG_SESSION_ID
			fi

			if [ -x "$HOME/.xsession" ]; then
			    eval exec "$HOME/.xsession" "$@"
			fi

			if [ -n "$1" ]; then
			    eval exec "$@"
			else
			    exit 1
			fi
		'';
in {
	services.displayManager.ly = {
		enable = true;

		settings = {
			save = true;
			load = true;

			setup_cmd = "${lySetup}";

			xinitrc = "null";
		};
	};
}
