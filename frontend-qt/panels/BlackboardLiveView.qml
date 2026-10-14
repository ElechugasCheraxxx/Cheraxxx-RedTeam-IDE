import QtQuick
import "../theme"

Rectangle {
    color: Theme.bgPanel
    border.color: Qt.rgba(1, 1, 1, 0.1)

    Column {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: 10

        Text {
            text: "BLACKBOARD LIVE VIEW"
            color: Theme.primary
            font.pixelSize: 11
            font.bold: true
            font.family: Theme.monoFont
        }

        // Network Graph Placeholder
        Canvas {
            id: graphCanvas
            width: parent.width
            height: parent.height - 40

            property var nodes: bridge.snapshot.nodes || []

            onNodesChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                if (!nodes || nodes.length === 0) {
                    return;
                }

                ctx.strokeStyle = Theme.primary;
                ctx.fillStyle = Theme.primary;
                ctx.lineWidth = 1;
                ctx.font = "8px " + Theme.monoFont;

                var centerX = width / 2;
                var centerY = height / 2;
                var radius = Math.min(width, height) * 0.35;

                for (var i = 0; i < nodes.length; i++) {
                    var angle = (i / nodes.length) * 2 * Math.PI;
                    var x = centerX + radius * Math.cos(angle);
                    var y = centerY + radius * Math.sin(angle);

                    nodes[i].x = x;
                    nodes[i].y = y;

                    // Draw Node
                    ctx.beginPath();
                    ctx.arc(x, y, 5, 0, 2 * Math.PI);
                    ctx.fill();

                    // Draw Label
                    ctx.fillStyle = Theme.textPrimary;
                    ctx.fillText(nodes[i].id || ("Node " + i), x + 8, y + 3);
                    ctx.fillStyle = Theme.primary;
                }

                // Draw Connections
                ctx.strokeStyle = Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.3);
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i].connections) {
                        for (var j = 0; j < nodes[i].connections.length; j++) {
                            var targetId = nodes[i].connections[j];
                            var targetNode = nodes.find(n => n.id === targetId);
                            if (targetNode) {
                                ctx.beginPath();
                                ctx.moveTo(nodes[i].x, nodes[i].y);
                                ctx.lineTo(targetNode.x, targetNode.y);
                                ctx.stroke();
                            }
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                visible: !graphCanvas.nodes || graphCanvas.nodes.length === 0
                text: "[ NO NODES DISCOVERED ]"
                color: Theme.muted
                font.pixelSize: 10
            }
        }
    }
}
