import QtQuick
import QtQuick.Controls
import "../theme"

Rectangle {
    color: Theme.bgPanel
    border.color: Qt.rgba(1, 1, 1, 0.1)

    Column {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: 10

        Text {
            text: "AUTONOMY CONTROLS"
            color: Theme.textPrimary
            font.pixelSize: 11
            font.bold: true
            font.family: Theme.monoFont
        }

        Text {
            text: "AUTONOMY LEVEL: " + (bridge.snapshot.autonomy_level || "HIGH")
            color: Theme.success
            font.pixelSize: 10
            font.family: Theme.monoFont
        }

        Slider {
            width: parent.width
            value: bridge.snapshot.autonomy_value || 0.8
            background: Rectangle { height: 4; color: "#1A1A1C"; radius: 2 }
            handle: Rectangle { width: 12; height: 12; radius: 6; color: Theme.primary; x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width) }
            onMoved: {
                // bridge.setAutonomy(value) - assuming such method exists or will be added
            }
        }

        Button {
            width: parent.width
            text: "ADJUST PARAMETERS"
            contentItem: Text { text: parent.text; color: "black"; font.bold: true; horizontalAlignment: Text.AlignHCenter }
            background: Rectangle { color: Theme.primary; radius: 4 }
        }
    }
}
