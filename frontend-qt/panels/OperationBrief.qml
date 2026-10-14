import QtQuick
import QtQuick.Controls
import "../theme"

Rectangle {
    color: Theme.bgPanel
    border.color: Qt.rgba(1, 1, 1, 0.1)

    Column {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: 12

        Text {
            text: "OPERATION BRIEF"
            color: Theme.accent
            font.pixelSize: 12
            font.bold: true
            font.family: Theme.monoFont
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.muted
            opacity: 0.3
        }

        Text {
            text: bridge.operationName
            color: Theme.textPrimary
            font.pixelSize: 18
            font.bold: true
        }

        BriefItem {
            label: "OBJECTIVE"
            value: bridge.snapshot.objective || "Gain persistent domain access and extract high-value data."
        }
        BriefItem {
            label: "SCOPE"
            value: bridge.snapshot.scope || "corp.internal / 10.0.0.0/16"
        }
        BriefItem {
            label: "CONSTRAINTS"
            value: bridge.snapshot.constraints || "• No internet access\n• AV/EDR present\n• Domain hardening enabled"
        }
    }
}
