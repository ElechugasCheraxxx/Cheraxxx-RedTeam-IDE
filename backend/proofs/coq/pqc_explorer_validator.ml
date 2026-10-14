
type bool =
| True
| False

type sumbool =
| Left
| Right

(** val bool_dec : bool -> bool -> sumbool **)

let bool_dec b1 b2 =
  match b1 with
  | True -> (match b2 with
             | True -> Left
             | False -> Right)
  | False -> (match b2 with
              | True -> Right
              | False -> Left)

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

type vulnType =
| WeakAlgo
| HardcodedSeed
| NonceReuse
| WeakPRNG
| UnprotectedKey

(** val isVulnerable_bool : string -> vulnType -> bool **)

let isVulnerable_bool code = function
| WeakAlgo ->
  (match string_dec code (String ((Ascii (True, True, False, True, False,
           True, True, False)), (String ((Ascii (True, False, False, True,
           True, True, True, False)), (String ((Ascii (False, True, False,
           False, False, True, True, False)), (String ((Ascii (True, False,
           True, False, False, True, True, False)), (String ((Ascii (False,
           True, False, False, True, True, True, False)), (String ((Ascii
           (True, True, True, True, True, False, True, False)), (String
           ((Ascii (True, False, True, False, True, True, False, False)),
           (String ((Ascii (True, False, False, False, True, True, False,
           False)), (String ((Ascii (False, True, False, False, True, True,
           False, False)), EmptyString)))))))))))))))))) with
   | Left -> True
   | Right -> False)
| _ -> True
