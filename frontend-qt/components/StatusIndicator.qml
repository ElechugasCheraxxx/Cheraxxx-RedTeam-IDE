import QtQuick
import "../theme"

Row {
    property string label: ""
    property string status: ""
    property color color: Theme.success
    spacing: 6

    Rectangle { width: 6; height: 6; radius: 3; color: parent.color; anchors.verticalCenter: parent.verticalCenter }
    Text { text: label + ": " + status; color: Theme.textSecondary; font.pixelSize: 10; font.family: Theme.monoFont }
}
