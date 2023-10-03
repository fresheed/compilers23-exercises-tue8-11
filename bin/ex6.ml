module Sym = Util.Symbol
open Util.Ll
open Llvm.CfgBuilder
open Llvm
let symbol = Sym.symbol 

let fresh_symbol =
  let c = ref 0 in
  fun initial ->
    let n = !c in c := n + 1; symbol (initial ^ (string_of_int n))


(* string -> insn -> CfgBuilder.buildlet * operand *)
let add_instruction_with_fresh s i = 
  let res = fresh_symbol s in
  let bl = add_insn (Some res, i) in
  (bl, Id res)  


(* bop -> operand -> CfgBuilder.buildlet *)
let change_by_one_buildlet op loc = 
  let b_load, load_op = add_instruction_with_fresh "t" (Load (I64, loc)) in
  let b_binop, op = add_instruction_with_fresh "t" (Binop (op, I64, load_op, IConst64 1L)) in 
  let b_save = Llvm.CfgBuilder.add_insn (None, Store (I64, op, loc)) in 
  Llvm.CfgBuilder.seq_buildlets [ b_load; b_binop; b_save] 

(* CfgBuilder.buildlet *)
let exercise_buildlet: buildlet =  
  let inp_reg = fresh_symbol "v" in
  let x_ptr = fresh_symbol "p" in
  let ret_val = fresh_symbol "v" in
  let cond = fresh_symbol "c" in
  let pos = fresh_symbol "l" in
  let neg = fresh_symbol "l" in
  let fin = fresh_symbol "l" in
  seq_buildlets [
    (* allocate x pointer *)
    add_alloca (x_ptr, I64);
    (* read user input into a register *)
    add_insn (Some inp_reg, Call (I64, Gid (symbol "read_integer"), []));
    (* store the input into the pointer *)
    add_insn (None, Store (I64, Id inp_reg, Id x_ptr));

    (* branch depending on the value of x *)
    add_insn (Some cond, Icmp (Sge, I64, Id inp_reg, IConst64 0L));
    term_block (Cbr (Id cond, pos, neg)); 
    (* x := x + 1 if non-negative*)
    start_block pos;
    change_by_one_buildlet Add (Id x_ptr);  
    term_block (Br fin);
    (* x := x - 1 if negative*)
    start_block neg;
    change_by_one_buildlet Sub (Id x_ptr);  
    term_block (Br fin);

    start_block fin;
    (* get the current x value *)
    add_insn (Some ret_val, Load (I64, Id x_ptr));
    (* print it *)
    add_insn (None, Call (Void, Gid (symbol "print_integer"),
                          [(I64, Id ret_val)]));

    (* add a terminator *) 
    Ret (Void, None) |> term_block
  ]


let p : prog = 
  let b = exercise_buildlet CfgBuilder.empty_cfg_builder in 
  let cfg = CfgBuilder.get_cfg b in 
  let f = { fty = ([], Void); param = []; cfg = cfg} in 
  {
  tdecls = [];
  extgdecls = [];
  gdecls = [];
  extfuns = [ (symbol "print_integer",  ([I64], Void))
            ; (symbol "read_integer", ([], I64))];  
  fdecls = [ (symbol "dolphin_main", f )]
}


let write_to_file (path: string) (contents: string) =
  let oc = open_out path in
  Printf.fprintf oc "%s" contents;
  close_out oc


let run_with inp out = 
  let cmd = Printf.sprintf "echo Input %d, expected %d; echo '%d' | ./a.out; echo" inp out inp in
  ignore (Sys.command cmd)

let tests = [(5, 6); (-5, -6); (0, 1)]

let _ = 
  let asm = string_of_prog p in
  write_to_file "ex6.ll" asm;
  (* let compile = Sys.command "exit 1" in *)
  let compile = Sys.command "clang ex6_runner.c ex6.ll; echo =================" in
  if compile = 0 
  then List.iter (fun test -> run_with (fst test) (snd test)) tests
  else Printf.eprintf "Compilation error\n"
