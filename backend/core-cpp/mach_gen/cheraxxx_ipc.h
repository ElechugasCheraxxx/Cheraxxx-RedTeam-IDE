#ifndef	_cheraxxx_ipc_user_
#define	_cheraxxx_ipc_user_

/* Module cheraxxx_ipc */

#include <string.h>
#include <mach/ndr.h>
#include <mach/boolean.h>
#include <mach/kern_return.h>
#include <mach/notify.h>
#include <mach/mach_types.h>
#include <mach/message.h>
#include <mach/mig_errors.h>
#include <mach/port.h>

#include "cheraxxx_shared_types.h"

/* BEGIN VOUCHER CODE */

#ifndef KERNEL
#if defined(__has_include)
#if __has_include(<mach/mig_voucher_support.h>)
#ifndef USING_VOUCHERS
#define USING_VOUCHERS
#endif
#ifndef __VOUCHER_FORWARD_TYPE_DECLS__
#define __VOUCHER_FORWARD_TYPE_DECLS__
#ifdef __cplusplus
extern "C" {
#endif
#ifndef __VOUCHER_FOWARD_TYPE_DECLS_SINGLE_ATTR
#define __VOUCHER_FOWARD_TYPE_DECLS_SINGLE_ATTR __unsafe_indexable
#endif
	extern boolean_t voucher_mach_msg_set(mach_msg_header_t * msg) __attribute__((weak_import));
#ifdef __cplusplus
}
#endif
#endif // __VOUCHER_FORWARD_TYPE_DECLS__
#endif // __has_include(<mach/mach_voucher_types.h>)
#endif // __has_include
#endif // !KERNEL
	
/* END VOUCHER CODE */

	
/* BEGIN MIG_STRNCPY_ZEROFILL CODE */

#if defined(__has_include)
#if __has_include(<mach/mig_strncpy_zerofill_support.h>)
#ifndef USING_MIG_STRNCPY_ZEROFILL
#define USING_MIG_STRNCPY_ZEROFILL
#endif
#ifndef __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS__
#define __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS__
#ifdef __cplusplus
extern "C" {
#endif
#ifndef __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS_CSTRING_ATTR
#define __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS_CSTRING_COUNTEDBY_ATTR(C) __unsafe_indexable
#endif
	extern int mig_strncpy_zerofill(char * dest, const char * src, int len) __attribute__((weak_import));
#ifdef __cplusplus
}
#endif
#endif /* __MIG_STRNCPY_ZEROFILL_FORWARD_TYPE_DECLS__ */
#endif /* __has_include(<mach/mig_strncpy_zerofill_support.h>) */
#endif /* __has_include */
	
/* END MIG_STRNCPY_ZEROFILL CODE */


#ifdef AUTOTEST
#ifndef FUNCTION_PTR_T
#define FUNCTION_PTR_T
typedef void (*function_ptr_t)(mach_port_t, char *, mach_msg_type_number_t);
typedef struct {
        char            * name;
        function_ptr_t  function;
} function_table_entry;
typedef function_table_entry   *function_table_t;
#endif /* FUNCTION_PTR_T */
#endif /* AUTOTEST */

#ifndef	cheraxxx_ipc_MSG_COUNT
#define	cheraxxx_ipc_MSG_COUNT	3
#endif	/* cheraxxx_ipc_MSG_COUNT */

#include <Availability.h>
#include <mach/std_types.h>
#include <mach/mig.h>
#include <mach/mig.h>
#include <mach/mach_types.h>

#ifdef __BeforeMigUserHeader
__BeforeMigUserHeader
#endif /* __BeforeMigUserHeader */

#include <sys/cdefs.h>
__BEGIN_DECLS


/* Routine cheraxxx_dispatch_tactical_node */
#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
kern_return_t cheraxxx_dispatch_tactical_node
(
	mach_port_t server_port,
	int sender_id,
	int msg_type,
	int priority,
	tact_msg_payload_t payload,
	mach_msg_type_number_t payloadCnt
);

/* Routine cheraxxx_fetch_blackboard_state */
#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
kern_return_t cheraxxx_fetch_blackboard_state
(
	mach_port_t server_port,
	tact_msg_payload_t state_data,
	mach_msg_type_number_t *state_dataCnt
);

/* SimpleRoutine cheraxxx_signal_escalation */
#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
kern_return_t cheraxxx_signal_escalation
(
	mach_port_t server_port,
	int escalation_lvl,
	int reason_code
);

__END_DECLS

/********************** Caution **************************/
/* The following data types should be used to calculate  */
/* maximum message sizes only. The actual message may be */
/* smaller, and the position of the arguments within the */
/* message layout may vary from what is presented here.  */
/* For example, if any of the arguments are variable-    */
/* sized, and less than the maximum is sent, the data    */
/* will be packed tight in the actual message to reduce  */
/* the presence of holes.                                */
/********************** Caution **************************/

/* typedefs for all requests */

#ifndef __Request__cheraxxx_ipc_subsystem__defined
#define __Request__cheraxxx_ipc_subsystem__defined

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		int sender_id;
		int msg_type;
		int priority;
		mach_msg_type_number_t payloadCnt;
		char payload[1024];
	} __Request__cheraxxx_dispatch_tactical_node_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
	} __Request__cheraxxx_fetch_blackboard_state_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		int escalation_lvl;
		int reason_code;
	} __Request__cheraxxx_signal_escalation_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif
#endif /* !__Request__cheraxxx_ipc_subsystem__defined */

/* union of all requests */

#ifndef __RequestUnion__cheraxxx_ipc_subsystem__defined
#define __RequestUnion__cheraxxx_ipc_subsystem__defined
union __RequestUnion__cheraxxx_ipc_subsystem {
	__Request__cheraxxx_dispatch_tactical_node_t Request_cheraxxx_dispatch_tactical_node;
	__Request__cheraxxx_fetch_blackboard_state_t Request_cheraxxx_fetch_blackboard_state;
	__Request__cheraxxx_signal_escalation_t Request_cheraxxx_signal_escalation;
};
#endif /* !__RequestUnion__cheraxxx_ipc_subsystem__defined */
/* typedefs for all replies */

#ifndef __Reply__cheraxxx_ipc_subsystem__defined
#define __Reply__cheraxxx_ipc_subsystem__defined

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		kern_return_t RetCode;
	} __Reply__cheraxxx_dispatch_tactical_node_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		kern_return_t RetCode;
		mach_msg_type_number_t state_dataCnt;
		char state_data[1024];
	} __Reply__cheraxxx_fetch_blackboard_state_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		kern_return_t RetCode;
	} __Reply__cheraxxx_signal_escalation_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif
#endif /* !__Reply__cheraxxx_ipc_subsystem__defined */

/* union of all replies */

#ifndef __ReplyUnion__cheraxxx_ipc_subsystem__defined
#define __ReplyUnion__cheraxxx_ipc_subsystem__defined
union __ReplyUnion__cheraxxx_ipc_subsystem {
	__Reply__cheraxxx_dispatch_tactical_node_t Reply_cheraxxx_dispatch_tactical_node;
	__Reply__cheraxxx_fetch_blackboard_state_t Reply_cheraxxx_fetch_blackboard_state;
	__Reply__cheraxxx_signal_escalation_t Reply_cheraxxx_signal_escalation;
};
#endif /* !__RequestUnion__cheraxxx_ipc_subsystem__defined */

#ifndef subsystem_to_name_map_cheraxxx_ipc
#define subsystem_to_name_map_cheraxxx_ipc \
    { "cheraxxx_dispatch_tactical_node", 5000 },\
    { "cheraxxx_fetch_blackboard_state", 5001 },\
    { "cheraxxx_signal_escalation", 5002 }
#endif

#ifdef __AfterMigUserHeader
__AfterMigUserHeader
#endif /* __AfterMigUserHeader */

#endif	 /* _cheraxxx_ipc_user_ */
