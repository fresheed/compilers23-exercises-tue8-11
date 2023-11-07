{
	open Parpar
}

let digit = ['0'-'9']
let digits = digit+
let ident = ['a'-'z']+

rule token = parse
 | '+' { PLUS }
| '-' { MINUS }
| '*' { MULT }
| '/' { DIV }
| '(' { LPAREN }
| ')' { RPAREN }
| "val" { VAL }
| "input" { INPUT }
| '=' { EQ }
| ';' { SEMI }
| digits as i_lit { INT_LIT (int_of_string i_lit) }
| ident as x { IDENT x }
| ' ' { token lexbuf }
(* | "(*"  {  comment 0 lexbuf }  *)
| eof { EOF }
| _ { failwith "Unrecognized input"}

(* and comment nestingLevel = parse 
| "(*" { comment (nestingLevel + 1) lexbuf }
| "*)" { 
	if nestingLevel = 0 then 
	  token lexbuf 
	else 
	  comment (nestingLevel - 1) lexbuf
       }
| eof  { failwith "Broken comment" }
| _   { comment nestingLevel lexbuf }  
   *)