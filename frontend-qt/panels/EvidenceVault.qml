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
            text: "EVIDENCE VAULT"
            color: Theme.textPrimary
            font.pixelSize: 11
            font.bold: true
            font.family: Theme.monoFont
        }

        ListView {
            width: parent.width
            height: parent.height - 40
            model: bridge.snapshot.evidence || [
                { name: "dc-01_hashdump.txt", size: "2.4 MB", time: "22:41:15" },
                { name: "domain_creds.txt", size: "1.7 MB", time: "22:41:10" },
                { name: "sam_dump.bin", size: "64.0 MB", time: "22:41:18" }
            ]
            delegate: Row {
                width: parent.width
                spacing: 20
                Text { text: modelData.name; color: Theme.primary; font.pixelSize: 10; font.family: Theme.monoFont; width: parent.width * 0.5 }
                Text { text: modelData.size; color: Theme.muted; font.pixelSize: 10; font.family: Theme.monoFont; width: parent.width * 0.2 }
                Text { text: modelData.time; color: Theme.muted; font.pixelSize: 10; font.family: Theme.monoFont; width: parent.width * 0.2 }
            }
        }
    }
}
