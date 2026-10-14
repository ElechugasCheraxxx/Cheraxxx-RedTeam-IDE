#ifndef	_anti_debug_user_
#define	_anti_debug_user_

/* Module anti_debug */

#include <string.h>
#include <mach/ndr.h>
#include <mach/boolean.h>
#include <mach/kern_return.h>
#include <mach/notify.h>
#include <mach/mach_types.h>
#include <mach/message.h>
#include <mach/mig_errors.h>
#include <mach/port.h>
	
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

#ifndef	anti_debug_MSG_COUNT
#define	anti_debug_MSG_COUNT	3
#endif	/* anti_debug_MSG_COUNT */

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


/* SimpleRoutine anti_debug_report_violation */
#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
kern_return_t anti_debug_report_violation
(
	mach_port_t server_port,
	int violator_pid,
	int violation_type,
	int severity
);

/* Routine anti_debug_set_stealth_mode */
#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
kern_return_t anti_debug_set_stealth_mode
(
	mach_port_t server_port,
	boolean_t enabled
);

/* SimpleRoutine anti_debug_heartbeat */
#ifdef	mig_external
mig_external
#else
extern
#endif	/* mig_external */
kern_return_t anti_debug_heartbeat
(
	mach_port_t server_port,
	uint64_t integrity_token
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

#ifndef __Request__anti_debug_subsystem__defined
#define __Request__anti_debug_subsystem__defined

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		int violator_pid;
		int violation_type;
		int severity;
	} __Request__anti_debug_report_violation_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		boolean_t enabled;
	} __Request__anti_debug_set_stealth_mode_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		uint64_t integrity_token;
	} __Request__anti_debug_heartbeat_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif
#endif /* !__Request__anti_debug_subsystem__defined */

/* union of all requests */

#ifndef __RequestUnion__anti_debug_subsystem__defined
#define __RequestUnion__anti_debug_subsystem__defined
union __RequestUnion__anti_debug_subsystem {
	__Request__anti_debug_report_violation_t Request_anti_debug_report_violation;
	__Request__anti_debug_set_stealth_mode_t Request_anti_debug_set_stealth_mode;
	__Request__anti_debug_heartbeat_t Request_anti_debug_heartbeat;
};
#endif /* !__RequestUnion__anti_debug_subsystem__defined */
/* typedefs for all replies */

#ifndef __Reply__anti_debug_subsystem__defined
#define __Reply__anti_debug_subsystem__defined

#ifdef  __MigPackStructs
#pragma pack(push, 4)
#endif
	typedef struct {
		mach_msg_header_t Head;
		NDR_record_t NDR;
		kern_return_t RetCode;
	} __Reply__anti_debug_report_violation_t __attribute__((unused));
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
	} __Reply__anti_debug_set_stealth_mode_t __attribute__((unused));
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
	} __Reply__anti_debug_heartbeat_t __attribute__((unused));
#ifdef  __MigPackStructs
#pragma pack(pop)
#endif
#endif /* !__Reply__anti_debug_subsystem__defined */

/* union of all replies */

#ifndef __ReplyUnion__anti_debug_subsystem__defined
#define __ReplyUnion__anti_debug_subsystem__defined
union __ReplyUnion__anti_debug_subsystem {
	__Reply__anti_debug_report_violation_t Reply_anti_debug_report_violation;
	__Reply__anti_debug_set_stealth_mode_t Reply_anti_debug_set_stealth_mode;
	__Reply__anti_debug_heartbeat_t Reply_anti_debug_heartbeat;
};
#endif /* !__RequestUnion__anti_debug_subsystem__defined */

#ifndef subsystem_to_name_map_anti_debug
#define subsystem_to_name_map_anti_debug \
    { "anti_debug_report_violation", 6000 },\
    { "anti_debug_set_stealth_mode", 6001 },\
    { "anti_debug_heartbeat", 6002 }
#endif

#ifdef __AfterMigUserHeader
__AfterMigUserHeader
#endif /* __AfterMigUserHeader */

#endif	 /* _anti_debug_user_ */
