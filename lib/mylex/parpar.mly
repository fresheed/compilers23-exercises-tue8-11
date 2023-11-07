%{

 open Exercises.Ex2_defs_ext 

%}

%token EOF PLUS MINUS MULT DIV LPAREN RPAREN 
%token <int> INT_LIT 
%token VAL INPUT EQ 
%token <string> IDENT
%token SEMI

%left PLUS MINUS

%start <eprog> expr_stmt

%% 

%inline binop:
 | PLUS { Add }
 | MINUS { Sub }
 | DIV { Div }
 | MULT { Mul }

expr: 
  i = INT_LIT 
  { Int i }
| left = expr; op = binop; right = expr
  { BinOp (op, left, right)}
| LPAREN; e = expr; RPAREN 
  { e }
| idd = IDENT { Var idd }

stmt:
| VAL; v = IDENT; EQ; e = expr { Val (v, e) }
| INPUT; v = IDENT { Input (v) }

stmt_list:
  | l = separated_list (SEMI, stmt) { l }
  
expr_stmt: 
   |  l = stmt_list; EQ; e = expr; EOF { (l, e) }

