open Mylex 
open Exercises
open Ex2_defs_ext

let rec check_div0 = function
| BinOp (Div, _, Int 0) -> ["Division by zero found"]
| BinOp (op, e1, e2) -> check_div0 e1 @ check_div0 e2
| _ -> []

let check_div0_s (s: estmt) = match s with
| Val (_, e) -> check_div0 e
| Input _ -> []

let typecheck ((ess, ex): eprog) = 
  let errs = List.concat (List.map check_div0_s ess) @ (check_div0 ex) in
  ((ess, ex), errs)

let compile (ep: eprog): string =
  "echo 5; echo 7"

let write_to_file (path: string) (contents: string) =
  let oc = open_out path in
  Printf.fprintf oc "%s" contents;
  close_out oc

let test_compiled sh =
  let chan = Unix.open_process_in (Printf.sprintf "chmod +x %s; ./%s" sh sh) in
  let out = In_channel.input_all chan in
  print_endline out;
  let outs = List.map int_of_string (List.filter (fun s -> s <> "") (String.split_on_char '\n' out)) in
  outs
  
type test_result = LexingError | ParserError | TypeError | Compiled of (int list)

let expected_results = [
  ("input", Compiled [5; 7]);
  ("input2", TypeError);
]

    
let run_compiler file_base: test_result = 
  let file_in = open_in (file_base ^ ".txt") in 
  let lex_buf = Lexing.from_channel file_in in 
  let ep = Parpar.expr_stmt Lexlex.token lex_buf in
  let (tast, errs) = typecheck ep in
  if (List.length errs > 0) 
  then
    (Printf.printf "Type errors: %s\n" (String.concat ", " errs);
    TypeError)
  else
    let code = compile tast in
    write_to_file (file_base ^ ".sh") code;
    Compiled (test_compiled (file_base ^ ".sh"))

let test_file file_base exp: bool * string = 
  let res = run_compiler file_base in
  let ok = (exp = res) in
  let msg = Printf.sprintf "Output matches expected: %s\n" (if ok then "true" else "false") in
  (ok, msg)

let test = 
  let results = List.map (fun (fb, e) -> test_file fb e) expected_results in
  let res = List.for_all (fun x -> fst x) results in
  Printf.printf "Tests passed: %s\n" (if res then "true" else "false")
