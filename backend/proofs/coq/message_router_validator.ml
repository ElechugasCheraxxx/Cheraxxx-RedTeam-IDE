
type bool =
| True
| False

type nat =
| O
| S of nat

type 'a list =
| Nil
| Cons of 'a * 'a list

(** val length : 'a1 list -> nat **)

let rec length = function
| Nil -> O
| Cons (_, l') -> S (length l')

module Nat =
 struct
  (** val eqb : nat -> nat -> bool **)

  let rec eqb n m =
    match n with
    | O -> (match m with
            | O -> True
            | S _ -> False)
    | S n' -> (match m with
               | O -> False
               | S m' -> eqb n' m')

  (** val leb : nat -> nat -> bool **)

  let rec leb n m =
    match n with
    | O -> True
    | S n' -> (match m with
               | O -> False
               | S m' -> leb n' m')
 end

(** val filter : ('a1 -> bool) -> 'a1 list -> 'a1 list **)

let rec filter f = function
| Nil -> Nil
| Cons (x, l0) ->
  (match f x with
   | True -> Cons (x, (filter f l0))
   | False -> filter f l0)

type ascii =
| Ascii of bool * bool * bool * bool * bool * bool * bool * bool

type string =
| EmptyString
| String of ascii * string

(** val isValidRoute_bool : string -> string -> string -> bool **)

let isValidRoute_bool _ _ _ =
  True

(** val floodControl_bool : nat list -> nat -> bool **)

let floodControl_bool msgs_priority limit =
  Nat.leb (length (filter (fun p -> Nat.eqb p O) msgs_priority)) limit
