#pragma once

#include <string>
#include <vector>
#include <map>
#include <mutex>

namespace cheraxxx {

struct PayloadVariant {
    std::string id;
    std::string content;
    std::vector<std::string> techniques;
};

class PayloadManager {
public:
    static PayloadManager& getInstance() {
        static PayloadManager instance;
        return instance;
    }

    // --- Polymorphic Generation (Native C++) ---
    std::string obfuscateStrings(const std::string& code);
    std::string addJunkCode(const std::string& code);
    std::string b64EncodeLayer(const std::string& code);
    std::string xorEncodeLayer(const std::string& code, int key = 42);
    std::string pqcArmorLayer(const std::string& code); // Phase 4.2/4.3

    std::vector<std::string> generateVariants(const std::string& original, int count = 3);

    // --- OS Packaging ---
    std::string wrapForOS(const std::string& payload, const std::string& os_type);
    std::string generateZigStub(uint32_t seed);

private:
    PayloadManager() = default;
    std::mutex mtx;
};

} // namespace cheraxxx
