(* Defining the type for binary operations *)
type binop =
  | Add | Sub | Mul | Div

type varname = string                (* variable names are strings *)

(* Defining the type for arithmetic expressions *)
type expr =
  | Int of int                       (* Integer constant *)
  | BinOp of binop * expr * expr     (* Binary operation *)
  | Var of varname                   (* Variable lookup  *)


(* Defining the type of statements *)  
type estmt = 
  | Val of varname * expr            (* Binding variable to a value *)
  | Input of varname                 (* Input statement *)

(* Expression program is a list of statements 
   followed by an expression *) 
type eprog = estmt list * expr

let string_of_var (var): string = var

let string_of_binop (bin:binop) : string = match bin with
| Add -> "+"
| Sub -> "-"
| Mul -> "*" 
| Div -> "/"

let rec string_of_expr (e:expr) : string = match e with
  | Int a -> string_of_int a
  | BinOp (bin, expr_l, expr_r) -> Printf.sprintf ("( %s %s %s )") 
          (string_of_expr expr_l) (string_of_binop bin) (string_of_expr expr_r)
  | Var var -> string_of_var var

let string_of_estmt (estm:estmt) : string = match estm with
  | Val (v, e) -> Printf.sprintf ("val %s = %s") (string_of_var v) (string_of_expr e)
  | Input v -> Printf.sprintf("input %s") (string_of_var v)

let rec string_of_eprog ((lst, e): eprog) = match (lst, e) with
  | ([], e) -> Printf.sprintf ("return %s") (string_of_expr e)
  | (h::t, e) -> (Printf.sprintf("%s \n") (string_of_estmt h)) ^ (string_of_eprog (t,e))
