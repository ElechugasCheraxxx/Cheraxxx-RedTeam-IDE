import QtQuick
import QtQuick.Shapes
import "../../theme"

Rectangle {
    id: root
    color: Theme.bgCard
    border.color: Theme.border
    border.width: 1
    radius: 4
    clip: true

    property var phases: [] // Array of { name: "", commands: [] }

    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        text: "CHOREOGRAPHY FLOW"
        color: Theme.accent
        font.pixelSize: 10
        font.bold: true
    }

    Row {
        anchors.centerIn: parent
        spacing: 60

        Repeater {
            model: root.phases
            delegate: Item {
                width: 120
                height: 200

                Rectangle {
                    width: parent.width
                    height: 40
                    color: Theme.bgLighter
                    border.color: Theme.accent
                    radius: 4
                    Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: "white"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                Column {
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    spacing: 5
                    width: parent.width

                    Repeater {
                        model: modelData.commands
                        delegate: Rectangle {
                            width: parent.width
                            height: 25
                            color: "#1a1a1a"
                            border.color: "#333"
                            radius: 2
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: "#888"
                                font.pixelSize: 10
                                font.family: "JetBrains Mono"
                            }
                        }
                    }
                }

                // Connection Arrow
                Shape {
                    visible: index < root.phases.length - 1
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.top
                    anchors.verticalCenterOffset: 20
                    width: 60
                    height: 2
                    ShapePath {
                        strokeColor: Theme.accent
                        strokeWidth: 2
                        startX: 0; startY: 1
                        PathLine { x: 50; y: 1 }
                        // Arrow head
                        PathLine { x: 45; y: -4 }
                        PathMove { x: 50; y: 1 }
                        PathLine { x: 45; y: 6 }
                    }
                }
            }
        }
    }
}
