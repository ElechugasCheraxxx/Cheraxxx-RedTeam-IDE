#include "Ghost.hpp"
#include "ToolDispatcher.hpp"
#include "Blackboard.hpp"
#include "interop/AtlasSwarmClient.hpp"
#include <iostream>

namespace cheraxxx {

GhostAgent::GhostAgent(const std::string& model_path)
    : NativeAgent("ghost", model_path) {

    std::cout << "[Ghost] Connecting to Atlas Swarm..." << std::endl;
    try {
        network::AtlasSwarmClient client("/tmp/cheraxxx_atlas.sock");
        client.register_agent("ghost_01", "macOS", "arm64");
    } catch (...) {}
}

void GhostAgent::onResponseGenerated(const std::string& raw_output) {
    // Ghost se encarga de la explotación y payloads usando extracción GBNF.
    json data = ToolDispatcher::getInstance().parseGBNFResponse(raw_output);

    // Report reasoning to Atlas
    try {
        network::AtlasSwarmClient client("/tmp/cheraxxx_atlas.sock");
        client.route_message("ghost", "atlas", "REASONING_OUTPUT", raw_output);
    } catch (...) {}

    if (data.count("payload")) {
        std::string payload = data["payload"];
        std::string method = data.count("execution") ? data["execution"] : "direct_exec";

        std::cout << "[Ghost] Action: Deploying " << method << " payload via Ghost Remap..." << std::endl;

        // Notify mission update
        try {
            network::AtlasSwarmClient client("/tmp/cheraxxx_atlas.sock");
            client.route_message("ghost", "atlas", "MISSION_UPDATE", "GHOST_REMAP_STARTED:" + method);
        } catch (...) {}

        if (method == "pipe") {
            std::string output = executeInMemory("bash", payload);
            std::cout << "[Ghost] Pipe Execution Output: " << output << std::endl;

            try {
                network::AtlasSwarmClient client("/tmp/cheraxxx_atlas.sock");
                client.route_message("ghost", "atlas", "MISSION_RESULT", output);
            } catch (...) {}
        }
    }
}

} // namespace cheraxxx
