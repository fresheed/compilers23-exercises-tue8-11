open Exercises.Ex2_defs

(* step 1: write a function that converts Int expressions into .dot format *)
(* step 2: extend it to support first-level binops *)
(* step 3: extend it to support arbitrary depth expressions *)

let binop_to_string op = 
  match op with
  | Add -> "Add" | Sub -> "Sub" | Mul -> "Mul" | Div -> "Div"
  
let construct_dot_contents (s: string) =
  Printf.sprintf "digraph AST {\n %s \n}" s 

(* An implementation that doesn't require passing accumulator-like argument into recursive call *)
let rec expr_to_dot (e: expr) (id: string): string = 
 match e with
 | Int n -> Printf.sprintf "%s [label=\"Int %i\"];" id n
 | BinOp (op, expr1, expr2) -> 
   let op_str = Printf.sprintf "%s [label=\"%s\"];" id (binop_to_string op) in
   let id1 = id ^ "a" in
   let id2 = id ^ "b" in
   let e1_str = expr_to_dot expr1 id1 in
   let e2_str = expr_to_dot expr2 id2 in
   let nodes_str = Printf.sprintf "%s \n %s \n %s" op_str e1_str e2_str in
   let edges_str = Printf.sprintf "\n %s -> %s; \n %s -> %s;" id id1 id id2 in
   nodes_str ^ edges_str

let write_dot_file (contents: string) =
 let oc = open_out "graph.dot" in
 Printf.fprintf oc "%s" contents;
 close_out oc

(* let test_expr = Int 5 *)
(* let test_expr = BinOp (Add, Int 5, Int 1) *)
let test_expr = BinOp (Add, BinOp (Sub, Int 3, Int 4), Int 1)
let _ = write_dot_file (construct_dot_contents (expr_to_dot test_expr "a"))