
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

(** val eq_op_phase : operationPhase -> operationPhase -> bool **)

let eq_op_phase a b =
  match a with
  | INIT -> (match b with
             | INIT -> true
             | _ -> false)
  | BRIEFING -> (match b with
                 | BRIEFING -> true
                 | _ -> false)
  | RECON -> (match b with
              | RECON -> true
              | _ -> false)
  | ANALYSIS -> (match b with
                 | ANALYSIS -> true
                 | _ -> false)
  | VULN_RESEARCH -> (match b with
                      | VULN_RESEARCH -> true
                      | _ -> false)
  | EXPLOITATION -> (match b with
                     | EXPLOITATION -> true
                     | _ -> false)
  | POST_EXPLOITATION -> (match b with
                          | POST_EXPLOITATION -> true
                          | _ -> false)
  | POST_OP -> (match b with
                | POST_OP -> true
                | _ -> false)
  | REPORTING -> (match b with
                  | REPORTING -> true
                  | _ -> false)
  | CLEANUP -> (match b with
                | CLEANUP -> true
                | _ -> false)
  | PAUSED -> (match b with
               | PAUSED -> true
               | _ -> false)
  | CLOSED -> (match b with
               | CLOSED -> true
               | _ -> false)

(** val isLegalTransition : operationPhase -> operationPhase -> bool **)

let isLegalTransition from to0 =
  match from with
  | INIT ->
    (match to0 with
     | BRIEFING -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | BRIEFING ->
    (match to0 with
     | RECON -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | RECON ->
    (match to0 with
     | ANALYSIS -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | ANALYSIS ->
    (match to0 with
     | VULN_RESEARCH -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | VULN_RESEARCH ->
    (match to0 with
     | EXPLOITATION -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | EXPLOITATION ->
    (match to0 with
     | POST_EXPLOITATION -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | POST_EXPLOITATION ->
    (match to0 with
     | POST_OP -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | POST_OP ->
    (match to0 with
     | REPORTING -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | REPORTING ->
    (match to0 with
     | CLEANUP -> true
     | PAUSED -> true
     | _ -> eq_op_phase from to0)
  | CLEANUP ->
    (match to0 with
     | PAUSED -> true
     | CLOSED -> true
     | _ -> eq_op_phase from to0)
  | PAUSED -> true
  | CLOSED -> (match to0 with
               | PAUSED -> true
               | _ -> eq_op_phase from to0)

(** val isValidPath : operationPhase -> operationPhase list -> bool **)

let rec isValidPath start = function
| [] -> true
| next::rest ->
  if isLegalTransition start next then isValidPath next rest else false
