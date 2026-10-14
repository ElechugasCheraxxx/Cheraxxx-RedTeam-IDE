
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

module Pos :
 sig
  val eq_dec : positive -> positive -> sumbool
 end

val forallb : ('a1 -> bool) -> 'a1 list -> bool

module Z :
 sig
  val eq_dec : z -> z -> sumbool
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

val processSafe_bool : process -> bool

val systemSafe_bool : kernelState -> bool

val safeToInject_bool : z -> z -> bool
