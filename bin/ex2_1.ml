open Exercises.Ex2_defs

(* BinOp Add
├── Int 1
└── BinOp Mul
    ├── Int 2
    └── Int 3 *)

(* step 1: implement a function that prints (at least) Int expressions *)
(* step 2: extend this function to print first-level BinOp expressions *)
(* step 3: extend this function arbitrary expressions, but without arrows *)
(* step 4: print arrows (TBD) *)


let binop_to_string op = 
  match op with
  | Add -> "Add" | Sub -> "Sub" | Mul -> "Mul" | Div -> "Div"


(* The functions below are commented out to not trigger 'unused' warnings. 
   Feel free to uncomment and experiment with them *)
(*
let offset = "    "
let rec tree_to_string' (e: expr): string = 
  match e with
  | Int n -> "Int " ^ string_of_int n
  | BinOp (op, e1, e2) -> "BinOp " ^ binop_to_string op ^ "\n" ^ offset ^ (tree_to_string' e1) ^
                          "\n" ^ offset ^ (tree_to_string' e2) 
let rec tree_to_string'' (e: expr): string = 
match e with
| Int n -> "Int " ^ string_of_int n
| BinOp (op, e1, e2) -> Printf.sprintf "BinOp %s\n%s%s\n%s%s"
  (binop_to_string op) offset (tree_to_string'' e1) offset (tree_to_string'' e2) *)


let rec make_offset (depth: int) = if (depth = 0) then "" else "    " ^ make_offset (depth - 1) 

(** [depth] should be non-negative *)
let rec tree_to_string_impl (e: expr) (depth: int): string = 
  let offset = make_offset depth in
  match e with
  | Int n -> Printf.sprintf "%s Int %i" offset n
  | BinOp (op, e1, e2) -> Printf.sprintf "%s BinOp %s\n%s%s\n%s%s" offset
    (binop_to_string op) offset (tree_to_string_impl e1 (depth + 1)) 
    offset(tree_to_string_impl e2 (depth + 1)) 

let tree_to_string e = tree_to_string_impl e 0

let _ = print_endline (tree_to_string (Int 5))
let _ = print_endline (tree_to_string (BinOp (Sub, Int 5, Int 1)))
let _ = print_endline (tree_to_string (BinOp (Sub, BinOp (Mul, Int 1, Int 4), Int 1)))


