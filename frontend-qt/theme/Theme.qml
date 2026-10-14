import QtQuick

pragma Singleton

QtObject {
    // Primary Colors
    readonly property color bgDark: "#0A0A0B"
    readonly property color bgPanel: "#121214"
    readonly property color primary: "#3EBCFF"
    readonly property color accent: "#FF3E3E"
    readonly property color success: "#4CAF50"
    readonly property color warning: "#FFC107"
    readonly property color muted: "#666666"
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#AAAAAA"

    // Cyber Colors from Image
    readonly property color intelPurple: "#B07DFF"
    readonly property color glowBlue: "#00A3FF"

    // Layout Constants
    readonly property int sidebarWidth: 240
    readonly property int topBarHeight: 40
    readonly property int bottomBarHeight: 60
    readonly property int padding: 12
    readonly property int spacing: 8

    // Fonts
    readonly property string monoFont: "Monaco" // Or "JetBrains Mono" if available
}
