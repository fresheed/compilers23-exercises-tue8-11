(* Defining the type for binary operations *)
type binop = Add | Sub | Mul | Div

(* Defining the type for arithmetic expressions *)
type expr 
  = Int of int                       (* Integer constant *)
  | BinOp of binop * expr * expr     (* Binary operation *) 

let expr1 = BinOp (Sub, 
                  (BinOp (Mul,
                          BinOp (Add,  
                                (Int 3),
                                (Int 4)
                                ),
                         (Int 7))),
                  (Int 2)
)