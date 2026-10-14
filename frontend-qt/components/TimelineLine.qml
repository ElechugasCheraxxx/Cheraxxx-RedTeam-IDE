import QtQuick
import "../theme"

Rectangle {
    property bool active: false
    width: 60
    height: 2
    color: active ? Theme.accent : Theme.muted
    opacity: active ? 1.0 : 0.3
    anchors.verticalCenter: parent.verticalCenter
}
