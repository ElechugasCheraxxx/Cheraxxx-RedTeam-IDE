import QtQuick
import "../theme"

Column {
    property string label: ""
    property string time: ""
    property bool active: false
    spacing: 4

    Rectangle {
        width: 10; height: 10; radius: 5
        color: active ? Theme.accent : Theme.muted
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text { text: label; color: active ? Theme.textPrimary : Theme.muted; font.pixelSize: 8; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
    Text { text: time; color: Theme.muted; font.pixelSize: 7; anchors.horizontalCenter: parent.horizontalCenter }
}
