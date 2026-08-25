import QtQuick
import QtQuick.Layouts

Item {
	id: root

	focus: true

	required property list<string> values
	property string initValue

	property int index: 0
	property string value: values[index] ?? "..."

	function selectInitValue() {
		if (!initValue && initValue === "") {
			return;
		}

		const index = root.values.indexOf(initValue);

		if (index === -1) {
			return;
		}

		root.index = index;
	}

	onValuesChanged: selectInitValue()
	onInitValueChanged: selectInitValue()

	readonly property color textColor: selector.color
	readonly property var font: selector.font

	property bool readOnly: false

	property int minLength: {
		if (!root.values || root.values.length <= 0) {
			return 0;
		}

		let minLength = root.values[0].length;

		for (let i = 1; i < root.values.length; i++) {
			if (root.values[i].length > minLength) {
				minLength = root.values[i].length;
			}
		}

		return minLength;
	}

	readonly property alias minimumWidth: selector.minimumWidth
	property alias preferredWidth: selector.preferredWidth

	// Movement

	function selectLeft() {
		if (!root.readOnly) {
			root.index = (root.index + 1) % root.values.length;
		}
	}

	Shortcut {
		enabled: root.activeFocus

		sequences: ["Meta+D", "D", "Left"]

		onActivated: root.selectLeft()
	}

	function selectRight() {
		if (!root.readOnly) {
			root.index = (root.index - 1 + root.values.length) % root.values.length;
		}
	}

	Shortcut {
		enabled: root.activeFocus

		sequences: ["Meta+A", "A", "Right"]

		onActivated: root.selectRight()
	}

	implicitWidth: content.implicitWidth
	implicitHeight: content.implicitHeight

	RowLayout {
		id: content

		Layout.alignment: Qt.AlignHCenter
		spacing: 0

		Text {
			text: "< "

			color: selector.color
			font: selector.font
		}

		Text {
			id: selector

			text: root.value
			horizontalAlignment: Text.AlignHCenter

			color: root.activeFocus ? Theme.values.textPrimary : Theme.values.textMuted

			font {
				family: Theme.values.fontMonospace
				pixelSize: Theme.values.fontSize
			}

			FontMetrics {
				id: fontMetrics
				font: selector.font
			}

			readonly property int minimumWidth: fontMetrics.averageCharacterWidth * root.minLength
			property int preferredWidth: 0

			Layout.minimumWidth: minimumWidth
			Layout.preferredWidth: preferredWidth
		}

		Text {
			text: " >"

			color: selector.color
			font: selector.font
		}
	}
}
