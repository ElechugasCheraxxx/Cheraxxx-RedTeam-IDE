import QtQuick
import QtQuick.Layouts
import "../theme"

Rectangle {
    color: Theme.bgPanel
    border.color: Qt.rgba(1, 1, 1, 0.1)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.padding

        Text {
            text: "CIPHER COMMAND CENTER (META-ORCHESTRATOR)"
            color: Theme.accent
            font.pixelSize: 11
            font.bold: true
            font.family: Theme.monoFont
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            // Avatar Container
            Rectangle {
                width: 120
                height: 150
                color: "black"
                border.color: Theme.accent
                border.width: 1
                opacity: 0.8

                // Using a generic placeholder if image not found
                Text {
                    anchors.centerIn: parent
                    text: "CIPHER\nORCHESTRATOR"
                    color: Theme.accent
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Text {
                    text: "STRATEGIC PLAN"
                    color: Theme.muted
                    font.pixelSize: 10
                    font.bold: true
                    font.family: Theme.monoFont
                }

                Repeater {
                    model: bridge.snapshot.strategic_plan || ["Expand foothold", "Enumerate trust", "Identify paths", "Acquire creds"]
                    delegate: Text {
                        text: (index < 9 ? "0" : "") + (index + 1) + " " + modelData
                        color: Theme.textSecondary
                        font.pixelSize: 10
                        font.family: Theme.monoFont
                    }
                }

                Item { Layout.fillHeight: true }

                MetricBox {
                    label: "STRATEGIC CONFIDENCE"
                    value: Math.round(bridge.confidence * 100) + "%"
                }
            }
        }

        // Reasoning Panel
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.05)
            border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.3)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Text {
                    text: "CURRENT DIRECTIVE"
                    color: Theme.accent
                    font.pixelSize: 9
                    font.bold: true
                    font.family: Theme.monoFont
                }

                Text {
                    text: bridge.snapshot.current_directive || "Enumerate and abuse ACLs for privilege escalation."
                    color: Theme.textPrimary
                    font.pixelSize: 11
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }

                Text {
                    text: "REASONING: " + (bridge.snapshot.reasoning || "Analyzing machines with unconstrained delegation.")
                    color: Theme.muted
                    font.pixelSize: 9
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    font.italic: true
                    font.family: Theme.monoFont
                }
            }
        }
    }
}
