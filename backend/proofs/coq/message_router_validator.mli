
type bool =
| True
| False

type nat =
| O
| S of nat

type 'a list =
| Nil
| Cons of 'a * 'a list

val length : 'a1 list -> nat

module Nat :
 sig
  val eqb : nat -> nat -> bool

  val leb : nat -> nat -> bool
 end

val filter : ('a1 -> bool) -> 'a1 list -> 'a1 list

type ascii =
| Ascii of bool * bool * bool * bool * bool * bool * bool * bool

type string =
| EmptyString
| String of ascii * string

val isValidRoute_bool : string -> string -> string -> bool

val floodControl_bool : nat list -> nat -> bool
