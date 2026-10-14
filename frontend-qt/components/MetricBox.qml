import QtQuick
import "../theme"

Column {
    property string label: ""
    property string value: ""

    Text { text: label; color: Theme.muted; font.pixelSize: 8; font.family: Theme.monoFont }
    Text { text: value; color: Theme.textPrimary; font.pixelSize: 14; font.bold: true; font.family: Theme.monoFont }
}
