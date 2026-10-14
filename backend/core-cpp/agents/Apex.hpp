#pragma once
#include "NativeAgent.hpp"
#include "GrammarLibrary.hpp"

namespace cheraxxx {

class ApexAgent : public NativeAgent {
public:
    ApexAgent(const std::string& model_path);
protected:
    void onResponseGenerated(const std::string& raw_output) override;
    std::string getGrammar() const override { return GrammarLibrary::APEX_GBNF; }
};

} // namespace cheraxxx
