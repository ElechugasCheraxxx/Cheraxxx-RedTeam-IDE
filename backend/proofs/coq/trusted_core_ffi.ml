open Sovereign_bridge_validator

(* Conversion helpers from OCaml native types to Coq-extracted types *)
let coq_bool_of_bool = function
  | true -> True
  | false -> False

let bool_of_coq_bool = function
  | True -> true
  | False -> false

let rec coq_nat_of_int n =
  if n <= 0 then Pdg_validator.O
  else Pdg_validator.S (coq_nat_of_int (n - 1))

let rec coq_positive_of_int n =
  if n <= 1 then XH
  else if n mod 2 = 0 then XO (coq_positive_of_int (n / 2))
  else XI (coq_positive_of_int (n / 2))

let coq_z_of_int n =
  if n = 0 then Z0
  else if n > 0 then Zpos (coq_positive_of_int n)
  else Zneg (coq_positive_of_int (-n))

let coq_ascii_of_char c =
  let n = Char.code c in
  let b i = coq_bool_of_bool ((n land (1 lsl i)) <> 0) in
  Pdg_validator.Ascii (b 0, b 1, b 2, b 3, b 4, b 5, b 6, b 7)

let rec coq_string_of_string s =
  let len = String.length s in
  let rec aux i =
    if i = len then Pdg_validator.EmptyString
    else Pdg_validator.String (coq_ascii_of_char s.[i], aux (i + 1))
  in aux 0

(* Sovereign Bridge FFI *)

let ffi_is_process_safe pid is_hidden is_protected is_opaque =
  let p = {
    pid = coq_z_of_int pid;
    is_hidden = coq_bool_of_bool is_hidden;
    is_protected = coq_bool_of_bool is_protected;
    is_opaque = coq_bool_of_bool is_opaque;
  } in
  bool_of_coq_bool (processSafe_bool p)

let ffi_is_safe_to_inject target_pid core_pid =
  bool_of_coq_bool (safeToInject_bool (coq_z_of_int target_pid) (coq_z_of_int core_pid))

(* PDG FFI *)

let ffi_pdg_is_acyclic ids =
  let primitives = List.map (fun id ->
    { Pdg_validator.pid = coq_string_of_string id;
      Pdg_validator.impact_weight = Pdg_validator.O;
      Pdg_validator.is_logic_flaw = false }
  ) ids in
  Pdg_validator.isAcyclic_bool primitives

(* State Machine FFI *)

let phase_of_int = function
  | 0 -> State_machine_validator.INIT
  | 1 -> BRIEFING | 2 -> RECON | 3 -> ANALYSIS | 4 -> VULN_RESEARCH
  | 5 -> EXPLOITATION | 6 -> POST_EXPLOITATION | 7 -> POST_OP
  | 8 -> REPORTING | 9 -> CLEANUP | 10 -> PAUSED | 11 -> CLOSED
  | _ -> PAUSED

let ffi_sm_is_legal_transition from_p to_p =
  bool_of_coq_bool (State_machine_validator.isLegalTransition (phase_of_int from_p) (phase_of_int to_p))

(* Data Surgery FFI *)

let ffi_verify_extraction art_id source_node integrity_hash is_corrupted =
  let art = {
    Data_surgery_validator.art_id = coq_string_of_string art_id;
    Data_surgery_validator.source_node = coq_string_of_string source_node;
    Data_surgery_validator.integrity_hash = coq_string_of_string integrity_hash;
    Data_surgery_validator.is_corrupted = coq_bool_of_bool is_corrupted;
  } in
  bool_of_coq_bool (Data_surgery_validator.extraction_Integrity_bool (coq_string_of_string art_id) art)

(* Message Router FFI *)

let ffi_is_valid_route from_agent to_agent channel =
  bool_of_coq_bool (Message_router_validator.isValidRoute_bool
    (coq_string_of_string from_agent)
    (coq_string_of_string to_agent)
    (coq_string_of_string channel))

(* PQC Explorer FFI *)

let vuln_type_of_int = function
  | 0 -> Pqc_explorer_validator.WeakAlgo
  | 1 -> Pqc_explorer_validator.HardcodedSeed
  | 2 -> Pqc_explorer_validator.NonceReuse
  | 3 -> Pqc_explorer_validator.WeakPRNG
  | _ -> Pqc_explorer_validator.UnprotectedKey

let ffi_pqc_is_vulnerable algo vuln_type_idx =
  bool_of_coq_bool (Pqc_explorer_validator.isVulnerable_bool
    (coq_string_of_string algo)
    (vuln_type_of_int vuln_type_idx))

(* Registering for C access *)
let () =
  Callback.register "ffi_is_process_safe" ffi_is_process_safe;
  Callback.register "ffi_is_safe_to_inject" ffi_is_safe_to_inject;
  Callback.register "ffi_pdg_is_acyclic" ffi_pdg_is_acyclic;
  Callback.register "ffi_sm_is_legal_transition" ffi_sm_is_legal_transition;
  Callback.register "ffi_verify_extraction" ffi_verify_extraction;
  Callback.register "ffi_is_valid_route" ffi_is_valid_route;
  Callback.register "ffi_pqc_is_vulnerable" ffi_pqc_is_vulnerable
