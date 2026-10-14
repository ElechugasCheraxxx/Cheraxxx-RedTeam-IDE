
type positive =
| XI of positive
| XO of positive
| XH



module Pos :
 sig
  val succ : positive -> positive

  val add : positive -> positive -> positive

  val add_carry : positive -> positive -> positive

  val pred_double : positive -> positive
 end

module Z :
 sig
  val double : int -> int

  val succ_double : int -> int

  val pred_double : int -> int

  val pos_sub : positive -> positive -> int
 end

val certified_add : int -> int -> int
