#pragma once

#include <string>
#include <vector>

namespace cheraxxx {

/**
 * ProcessManager handles external service dependencies (PostgreSQL, Llama-server, etc.)
 */
class ProcessManager {
public:
    static ProcessManager& getInstance() {
        static ProcessManager instance;
        return instance;
    }

    // Lifecycle
    void startServices();
    void stopServices();
    void setBasePath(const std::string& path);

private:
    ProcessManager() = default;
    ~ProcessManager() { stopServices(); }

    void spawnService(const std::string& command, const std::string& logFile);

    std::vector<int> active_pids;
    std::string base_path = "/Users/cheraxxx/Cheraxxx RedTeam IDE";
};

} // namespace cheraxxx
