
(** val negb : bool -> bool **)

let negb = function
| true -> false
| false -> true

type nat =
| O
| S of nat



type sumbool =
| Left
| Right

(** val bool_dec : bool -> bool -> sumbool **)

let bool_dec b1 b2 =
  if b1 then if b2 then Left else Right else if b2 then Right else Left

(** val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list **)

let rec map f = function
| [] -> []
| a::t -> (f a)::(map f t)

(** val existsb : ('a1 -> bool) -> 'a1 list -> bool **)

let rec existsb f = function
| [] -> false
| a::l0 -> if f a then true else existsb f l0

type ascii =
| Ascii of bool * bool * bool * bool * bool * bool * bool * bool

(** val ascii_dec : ascii -> ascii -> sumbool **)

let ascii_dec a b =
  let Ascii (b0, b1, b2, b3, b4, b5, b6, b7) = a in
  let Ascii (b8, b9, b10, b11, b12, b13, b14, b15) = b in
  (match bool_dec b0 b8 with
   | Left ->
     (match bool_dec b1 b9 with
      | Left ->
        (match bool_dec b2 b10 with
         | Left ->
           (match bool_dec b3 b11 with
            | Left ->
              (match bool_dec b4 b12 with
               | Left ->
                 (match bool_dec b5 b13 with
                  | Left ->
                    (match bool_dec b6 b14 with
                     | Left -> bool_dec b7 b15
                     | Right -> Right)
                  | Right -> Right)
               | Right -> Right)
            | Right -> Right)
         | Right -> Right)
      | Right -> Right)
   | Right -> Right)

type string =
| EmptyString
| String of ascii * string

(** val string_dec : string -> string -> sumbool **)

let rec string_dec s x =
  match s with
  | EmptyString -> (match x with
                    | EmptyString -> Left
                    | String (_, _) -> Right)
  | String (a, s0) ->
    (match x with
     | EmptyString -> Right
     | String (a0, s1) ->
       (match ascii_dec a a0 with
        | Left -> string_dec s0 s1
        | Right -> Right))

type primitive = { pid : string; impact_weight : nat; is_logic_flaw : bool }

(** val isValidChain_bool :
    primitive list -> (string -> string -> bool) -> bool **)

let isValidChain_bool chain check_edge =
  match chain with
  | [] -> true
  | _::_ ->
    let rec check = function
    | [] -> true
    | x::rest ->
      (match rest with
       | [] -> true
       | y::_ -> if check_edge x.pid y.pid then check rest else false)
    in check chain

(** val isAcyclic_bool : primitive list -> bool **)

let isAcyclic_bool chain =
  let has_dup =
    let rec has_dup l seen =
      match l with
      | [] -> false
      | h::t ->
        if existsb (fun s ->
             match string_dec h s with
             | Left -> true
             | Right -> false) seen
        then true
        else has_dup t (h::seen)
    in has_dup
  in
  negb (has_dup (map (fun p -> p.pid) chain) [])
