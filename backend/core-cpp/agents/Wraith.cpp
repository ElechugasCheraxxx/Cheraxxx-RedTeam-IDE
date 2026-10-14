#include "Wraith.hpp"
#include "ToolDispatcher.hpp"
#include "interop/AtlasSwarmClient.hpp"
#include <iostream>

namespace cheraxxx {

WraithAgent::WraithAgent(const std::string& model_path)
    : NativeAgent("wraith", model_path) {}

void WraithAgent::onResponseGenerated(const std::string& raw_output) {
    // Wraith: Evasión, mimetismo administrativo y Cognitive OPSEC.
    json data = ToolDispatcher::getInstance().parseGBNFResponse(raw_output);

    if (data.count("evasion_tactic")) {
        std::string tactic = data["evasion_tactic"];
        std::cout << "[Wraith] Executing Evasion Tactic: " << tactic << std::endl;

        try {
            network::AtlasSwarmClient client("/tmp/cheraxxx_atlas.sock");
            client.route_message("wraith", "atlas", "MISSION_UPDATE", "EVASION_ACTIVE:" + tactic);
        } catch (...) {}
    }
}

} // namespace cheraxxx
