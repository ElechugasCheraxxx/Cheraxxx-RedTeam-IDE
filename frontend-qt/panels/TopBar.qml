import QtQuick
import QtQuick.Layouts
import "../theme"

Rectangle {
    color: Theme.bgDark
    height: Theme.topBarHeight

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.padding
        anchors.rightMargin: Theme.padding

        Text {
            text: bridge.operationName
            color: Theme.textPrimary
            font.pixelSize: 14
            font.bold: true
            font.family: Theme.monoFont
        }

        Rectangle {
            width: 60
            height: 18
            color: bridge.operationName !== "IDLE" ? Theme.success : Theme.muted
            opacity: 0.2
            radius: 2
            Text {
                anchors.centerIn: parent
                text: bridge.operationName !== "IDLE" ? "ACTIVE" : "IDLE"
                color: parent.color
                font.pixelSize: 9
                font.bold: true
            }
        }

        Text {
            text: (bridge.snapshot.elapsed_time || "00:00:00") + " ELAPSED"
            color: Theme.textSecondary
            font.pixelSize: 12
            font.family: Theme.monoFont
        }

        Spacer { Layout.fillWidth: true }

        Row {
            spacing: 20
            StatusIndicator {
                label: "CIPHER"
                status: bridge.isBooted ? "ONLINE" : "OFFLINE"
                color: bridge.isBooted ? Theme.success : Theme.accent
            }
            StatusIndicator {
                label: "AGENTS"
                status: (bridge.snapshot.active_agents || "0") + " ONLINE"
                color: Theme.primary
            }
            StatusIndicator {
                label: "GPUS"
                status: {
                    var count = 0;
                    for(var i=0; i<bridge.hardwareNodes.length; i++) {
                        count += (bridge.hardwareNodes[i].gpus ? bridge.hardwareNodes[i].gpus.length : 0);
                    }
                    return count + " ONLINE";
                }
                color: Theme.success
            }
        }
    }
}
