import QtQuick
import "../theme"

Column {
    property string label: ""
    property string value: ""
    width: parent.width
    spacing: 4

    Text {
        text: label
        color: Theme.muted
        font.pixelSize: 9
        font.bold: true
        font.family: Theme.monoFont
    }

    Text {
        text: value
        color: Theme.textSecondary
        font.pixelSize: 11
        width: parent.width
        wrapMode: Text.WordWrap
        font.family: Theme.monoFont
    }
}
