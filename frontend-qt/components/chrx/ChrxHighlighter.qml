import QtQuick
import "../theme"

Item {
    id: highlighter
    property string text: ""

    // Simple regex-based syntax highlighting for .chrxxx
    function highlight(input) {
        if (!input) return "";

        let formatted = input
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;");

        // Keywords (Directives, Structural)
        const keywords = ["mission", "swarm", "agent", "flow", "choreography", "phase", "swarm_sync", "verify", "resource", "buffer", "strict_limit"];
        const kwRegex = new RegExp("\\b(" + keywords.join("|") + ")\\b", "g");
        formatted = formatted.replace(kwRegex, '<span style="color: ' + Theme.accent + '; font-weight: bold;">$1</span>');

        // Directives
        formatted = formatted.replace(/(@[a-zA-Z_]+)/g, '<span style="color: ' + Theme.warning + ';">$1</span>');

        // Commands
        const commands = ["bind", "await", "lock", "assert", "purge", "halt", "commit", "resume"];
        const cmdRegex = new RegExp("\\b(" + commands.join("|") + ")\\b", "g");
        formatted = formatted.replace(cmdRegex, '<span style="color: #61AFEF;">$1</span>');

        // Roles / Types
        const types = ["EXECUTION", "STEALTH", "BUFFER", "VOLATILE_POOL", "M4_PRO"];
        const typeRegex = new RegExp("\\b(" + types.join("|") + ")\\b", "g");
        formatted = formatted.replace(typeRegex, '<span style="color: #E5C07B;">$1</span>');

        // Literals (Numbers, Sizes)
        formatted = formatted.replace(/\b(\d+[BMG]?)\b/g, '<span style="color: #D19A66;">$1</span>');

        // Strings
        formatted = formatted.replace(/"([^"]*)"/g, '<span style="color: #98C379;">"$1"</span>');

        // Comments
        formatted = formatted.replace(/(\/\/.*)/g, '<span style="color: #5C6370; font-style: italic;">$1</span>');

        return formatted;
    }

    readonly property string highlightedText: highlight(text)
}
