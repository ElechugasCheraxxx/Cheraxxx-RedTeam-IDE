import QtQuick
import "../theme"

Row {
    property string label: ""
    property string value: ""
    property color colorValue: Theme.textSecondary
    spacing: 10

    Text { text: label; color: Theme.muted; font.pixelSize: 9; font.family: Theme.monoFont; width: 80 }
    Text { text: value; color: colorValue; font.pixelSize: 9; font.bold: true; font.family: Theme.monoFont }
}
