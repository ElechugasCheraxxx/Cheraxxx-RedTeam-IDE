#include <mach/mach.h>
#include <iostream>
#include <string>
#include "cheraxxx_ipc.h"
#include "Blackboard.hpp"
#include "EventSystem.hpp"

/*
 * TacticalMessageDispatcher.cpp
 * Se encarga de procesar los mensajes RPC que llegan vía Mach IPC y derivarlos
 * a los subsistemas internos (Blackboard, EventBus, etc.)
 */

extern "C" kern_return_t cheraxxx_dispatch_tactical_node(
    mach_port_t server_port,
    int sender_id,
    int msg_type,
    int priority,
    char* payload,
    mach_msg_type_number_t payloadCnt)
{
    std::string data(payload, payloadCnt);

    // Logica de ruteo interna según el tipo de mensaje (msg_type)
    if (msg_type == 100 || msg_type == 101) { // TACTICAL_XML_FINDING o CREDENTIAL
        // Inyectar en el Blackboard
        cheraxxx::Blackboard::getInstance().kvSet("last_mach_finding", data);

        // Publicar evento de hallazgo táctico
        cheraxxx::Event ev;
        ev.type = "TACTICAL_FINDING_MACH";
        ev.source = "MachIPC-Node-" + std::to_string(sender_id);
        ev.data = {{"raw", data}, {"msg_type", msg_type}};
        cheraxxx::EventBus::getInstance().publish(ev);

        // std::cout << "[Mach-Dispatcher] Injected tactical data from sender " << sender_id << std::endl;
    }

    return KERN_SUCCESS;
}

extern "C" kern_return_t cheraxxx_signal_escalation(
    mach_port_t server_port,
    int escalation_lvl,
    int reason_code)
{
    std::cerr << "[Mach-Dispatcher] !!! ESCALATION SIGNAL RECEIVED: Level " << escalation_lvl << " (Code: " << reason_code << ")" << std::endl;
    // Disparar lógica de alerta o cambio de fase global
    return KERN_SUCCESS;
}
