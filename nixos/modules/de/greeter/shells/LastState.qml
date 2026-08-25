pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

FileView {
	path: Quickshell.env("YGREETER_STATE") ?? ""

	onAdapterUpdated: writeAdapter()

	blockLoading: true

	property alias values: json

	// qmllint disable unresolved-type
	JsonAdapter {
		id: json

		property string lastUsername: ""
		property string lastSession: ""
	}
}
