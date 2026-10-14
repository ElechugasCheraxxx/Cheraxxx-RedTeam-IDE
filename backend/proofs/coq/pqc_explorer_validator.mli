
type bool =
| True
| False

type sumbool =
| Left
| Right

val bool_dec : bool -> bool -> sumbool

type ascii =
| Ascii of bool * bool * bool * bool * bool * bool * bool * bool

val ascii_dec : ascii -> ascii -> sumbool

type string =
| EmptyString
| String of ascii * string

val string_dec : string -> string -> sumbool

type vulnType =
| WeakAlgo
| HardcodedSeed
| NonceReuse
| WeakPRNG
| UnprotectedKey

val isVulnerable_bool : string -> vulnType -> bool
