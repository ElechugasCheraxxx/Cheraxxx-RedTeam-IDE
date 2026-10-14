import QtQuick
import QtQuick.Controls
import "../theme"

Rectangle {
    id: sidebar
    color: Theme.bgPanel
    border.color: Qt.rgba(1, 1, 1, 0.1)
    border.width: 1

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        Text {
            text: "NAVIGATION"
            color: Theme.muted
            font.pixelSize: 10
            font.bold: true
            font.family: Theme.monoFont
        }

        Repeater {
            model: ["Operation Brief", "Cipher Command Center", "Agent Workspaces", "Blackboard Live", "Communication Feed", "Hardware Monitor", "Evidence Vault", "Report Forge", "Persona Manager", "Settings"]

            delegate: Button {
                width: parent.width
                flat: true
                contentItem: Text {
                    text: modelData.toUpperCase()
                    color: hovered ? Theme.primary : Theme.textSecondary
                    font.pixelSize: 11
                    font.family: Theme.monoFont
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(1, 1, 1, 0.05) : "transparent"
                    border.color: parent.down ? Theme.primary : "transparent"
                }
            }
        }

        Spacer { height: 20 }

        Text {
            text: "OPERATION STATUS"
            color: Theme.muted
            font.pixelSize: 10
            font.bold: true
            font.family: Theme.monoFont
        }

        Column {
            spacing: 5
            StatusRow { label: "PHASE"; value: bridge.phase; colorValue: Theme.warning }
            StatusRow { label: "OBJECTIVE"; value: bridge.snapshot.short_objective || "REDACTED"; colorValue: Theme.primary }
            StatusRow { label: "CONFIDENCE"; value: Math.round(bridge.confidence * 100) + "%"; colorValue: Theme.success }
        }
    }
}
