import QtQuick
import QtQuick.Controls
import "../theme"

Rectangle {
    color: Theme.bgPanel
    border.color: Qt.rgba(1, 1, 1, 0.1)

    Column {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: 8

        Text {
            text: "COMMUNICATION FEED"
            color: Theme.textPrimary
            font.pixelSize: 11
            font.bold: true
            font.family: Theme.monoFont
        }

        ScrollView {
            width: parent.width
            height: parent.height - 100
            clip: true
            ListView {
                id: feedList
                model: bridge.eventLog
                spacing: 4
                delegate: Row {
                    spacing: 10
                    width: feedList.width
                    Text {
                        text: modelData.timestamp ? modelData.timestamp.split("T")[1].split(".")[0] : "--:--:--"
                        color: Theme.muted
                        font.pixelSize: 9
                        font.family: Theme.monoFont
                    }
                    Text {
                        text: modelData.source || "SYSTEM"
                        color: Theme.primary
                        font.pixelSize: 9
                        font.bold: true
                        font.family: Theme.monoFont
                        width: 60
                        elide: Text.ElideRight
                    }
                    Text {
                        text: modelData.message || ""
                        color: Theme.textSecondary
                        font.pixelSize: 10
                        font.family: Theme.monoFont
                        wrapMode: Text.WordWrap
                        width: parent.width - 120
                    }
                }

                onCountChanged: {
                    // Auto-scroll to bottom if needed, or maintain position
                }
            }
        }

        RowLayout {
            width: parent.width
            spacing: 8
            TextField {
                id: messageInput
                Layout.fillWidth: true
                placeholderText: "Type a message to agents..."
                font.pixelSize: 10
                color: Theme.textPrimary
                background: Rectangle { color: "#1A1A1C"; border.color: Theme.muted; opacity: 0.5 }
                onAccepted: {
                    bridge.injectMessage("ALL", text)
                    text = ""
                }
            }
            Button {
                text: "SEND"
                onClicked: {
                    bridge.injectMessage("ALL", messageInput.text)
                    messageInput.text = ""
                }
                // Custom styling for button would be better, but keeping it simple for now
            }
        }
    }
}
