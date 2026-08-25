import QtQuick

import "../config"

Text {
	text: Time.time
	color: Theme.values.textPrimary

	font {
		family: Theme.values.fontMonospace
		pixelSize: Theme.values.fontSize
	}
}
