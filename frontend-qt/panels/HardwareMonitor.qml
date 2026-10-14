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
            text: "HARDWARE MONITOR"
            color: Theme.primary
            font.pixelSize: 11
            font.bold: true
            font.family: Theme.monoFont
        }

        Row {
            spacing: 20
            MetricBox { label: "NODES"; value: bridge.hardwareNodes.length.toString() }
            MetricBox { label: "GPUS"; value: {
                var count = 0;
                for(var i=0; i<bridge.hardwareNodes.length; i++) {
                    count += bridge.hardwareNodes[i].gpus.length;
                }
                return count.toString();
            }}
            MetricBox { label: "VRAM"; value: "127.4 GB" }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.muted; opacity: 0.2 }

        Repeater {
            model: bridge.hardwareNodes
            delegate: Column {
                width: parent.width
                spacing: 4
                Text {
                    text: modelData.node_id + " (" + modelData.ip + ")"
                    color: Theme.textPrimary
                    font.pixelSize: 10
                    font.family: Theme.monoFont
                }
                Repeater {
                    model: modelData.gpus
                    delegate: Column {
                        width: parent.width
                        spacing: 2
                        Text { text: modelData.name; color: Theme.textSecondary; font.pixelSize: 8; font.family: Theme.monoFont }
                        ProgressBar {
                            width: parent.width
                            value: modelData.utilization / 100.0
                            background: Rectangle { color: "#1A1A1C"; radius: 2; height: 4 }
                            contentItem: Item {
                                Rectangle {
                                    width: parent.visualPosition * parent.width
                                    height: 4
                                    radius: 2
                                    color: modelData.utilization > 80 ? Theme.accent : Theme.primary
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
