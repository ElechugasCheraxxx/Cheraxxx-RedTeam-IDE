
type bool =
| True
| False

type 'a list =
| Nil
| Cons of 'a * 'a list

type sumbool =
| Left
| Right

type positive =
| XI of positive
| XO of positive
| XH

type z =
| Z0
| Zpos of positive
| Zneg of positive

module Pos =
 struct
  (** val eq_dec : positive -> positive -> sumbool **)

  let rec eq_dec p x0 =
    match p with
    | XI p0 -> (match x0 with
                | XI p1 -> eq_dec p0 p1
                | _ -> Right)
    | XO p0 -> (match x0 with
                | XO p1 -> eq_dec p0 p1
                | _ -> Right)
    | XH -> (match x0 with
             | XH -> Left
             | _ -> Right)
 end

(** val forallb : ('a1 -> bool) -> 'a1 list -> bool **)

let rec forallb f = function
| Nil -> True
| Cons (a, l0) -> (match f a with
                   | True -> forallb f l0
                   | False -> False)

module Z =
 struct
  (** val eq_dec : z -> z -> sumbool **)

  let eq_dec x y =
    match x with
    | Z0 -> (match y with
             | Z0 -> Left
             | _ -> Right)
    | Zpos p -> (match y with
                 | Zpos p0 -> Pos.eq_dec p p0
                 | _ -> Right)
    | Zneg p -> (match y with
                 | Zneg p0 -> Pos.eq_dec p p0
                 | _ -> Right)
 end

type ascii =
| Ascii of bool * bool * bool * bool * bool * bool * bool * bool

type string =
| EmptyString
| String of ascii * string

type process = { pid : z; is_hidden : bool; is_protected : bool;
                 is_opaque : bool }

type kernelState = { processes : process list;
                     network_stealth_enabled : bool; hidden_ports : z list;
                     hidden_files : string list }

(** val processSafe_bool : process -> bool **)

let processSafe_bool p =
  match p.is_hidden with
  | True -> p.is_protected
  | False -> True

(** val systemSafe_bool : kernelState -> bool **)

let systemSafe_bool ks =
  forallb processSafe_bool ks.processes

(** val safeToInject_bool : z -> z -> bool **)

let safeToInject_bool target_pid core_pid =
  match Z.eq_dec target_pid core_pid with
  | Left -> False
  | Right -> True
