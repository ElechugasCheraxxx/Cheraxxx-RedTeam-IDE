import QtQuick
import "../theme"

Rectangle {
    color: Theme.bgPanel
    border.color: Qt.rgba(1, 1, 1, 0.1)

    Column {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: 15

        Text {
            text: "OPERATION TIMELINE"
            color: Theme.accent
            font.pixelSize: 11
            font.bold: true
            font.family: Theme.monoFont
        }

        // Simple timeline representation
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            Repeater {
                model: bridge.snapshot.timeline || [
                    { label: "START", time: "19:34", active: true },
                    { label: "FOOTHOLD", time: "19:52", active: true },
                    { label: "PRIV ESC", time: "20:14", active: true },
                    { label: "LATERAL", time: "20:47", active: true },
                    { label: "EXFIL", time: "--:--", active: false }
                ]

                delegate: Row {
                    spacing: 0
                    TimelinePoint {
                        label: modelData.label
                        time: modelData.time
                        active: modelData.active
                    }
                    TimelineLine {
                        visible: index < (bridge.snapshot.timeline ? bridge.snapshot.timeline.length - 1 : 4)
                        active: modelData.active && (bridge.snapshot.timeline ? (index + 1 < bridge.snapshot.timeline.length && bridge.snapshot.timeline[index+1].active) : true)
                    }
                }
            }
        }
    }
}
