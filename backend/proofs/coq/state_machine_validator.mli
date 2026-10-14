
type operationPhase =
| INIT
| BRIEFING
| RECON
| ANALYSIS
| VULN_RESEARCH
| EXPLOITATION
| POST_EXPLOITATION
| POST_OP
| REPORTING
| CLEANUP
| PAUSED
| CLOSED

val eq_op_phase : operationPhase -> operationPhase -> bool

val isLegalTransition : operationPhase -> operationPhase -> bool

val isValidPath : operationPhase -> operationPhase list -> bool
