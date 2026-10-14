
type positive =
| XI of positive
| XO of positive
| XH



module Pos =
 struct
  (** val succ : positive -> positive **)

  let rec succ = function
  | XI p -> XO (succ p)
  | XO p -> XI p
  | XH -> XO XH

  (** val add : positive -> positive -> positive **)

  let rec add x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XO p ->
      (match y with
       | XI q -> XI (add p q)
       | XO q -> XO (add p q)
       | XH -> XI p)
    | XH -> (match y with
             | XI q -> XO (succ q)
             | XO q -> XI q
             | XH -> XO XH)

  (** val add_carry : positive -> positive -> positive **)

  and add_carry x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XI (add_carry p q)
       | XO q -> XO (add_carry p q)
       | XH -> XI (succ p))
    | XO p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XH ->
      (match y with
       | XI q -> XI (succ q)
       | XO q -> XO (succ q)
       | XH -> XI XH)

  (** val pred_double : positive -> positive **)

  let rec pred_double = function
  | XI p -> XI (XO p)
  | XO p -> XI (pred_double p)
  | XH -> XH
 end

module Z =
 struct
  (** val double : int -> int **)

  let double x =
     (fun _ -> assert false) 
      (fun _ -> 0)
      (fun p -> (XO p))
      (fun p -> (XO p))
      x

  (** val succ_double : int -> int **)

  let succ_double x =
     (fun _ -> assert false) 
      (fun _ -> XH)
      (fun p -> (XI p))
      (fun p -> (Pos.pred_double p))
      x

  (** val pred_double : int -> int **)

  let pred_double x =
     (fun _ -> assert false) 
      (fun _ -> XH)
      (fun p -> (Pos.pred_double p))
      (fun p -> (XI p))
      x

  (** val pos_sub : positive -> positive -> int **)

  let rec pos_sub x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> double (pos_sub p q)
       | XO q -> succ_double (pos_sub p q)
       | XH -> (XO p))
    | XO p ->
      (match y with
       | XI q -> pred_double (pos_sub p q)
       | XO q -> double (pos_sub p q)
       | XH -> (Pos.pred_double p))
    | XH ->
      (match y with
       | XI q -> (XO q)
       | XO q -> (Pos.pred_double q)
       | XH -> 0)
 end

(** val certified_add : int -> int -> int **)

let certified_add =
  (+)
