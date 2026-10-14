
val negb : bool -> bool

type nat =
| O
| S of nat



type sumbool =
| Left
| Right

val bool_dec : bool -> bool -> sumbool

val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list

val existsb : ('a1 -> bool) -> 'a1 list -> bool

type ascii =
| Ascii of bool * bool * bool * bool * bool * bool * bool * bool

val ascii_dec : ascii -> ascii -> sumbool

type string =
| EmptyString
| String of ascii * string

val string_dec : string -> string -> sumbool

type primitive = { pid : string; impact_weight : nat; is_logic_flaw : bool }

val isValidChain_bool : primitive list -> (string -> string -> bool) -> bool

val isAcyclic_bool : primitive list -> bool
