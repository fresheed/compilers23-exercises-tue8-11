(* open Util *)
open Util.Ll
open Llvm.CfgBuilder
(* open Exercises.CfgBuilder *)


let ret53_inss: (uid option * insn) list = []
let ret53_term: terminator = Ret (I64, Some (IConst64 53L))
let ret53_init_block: block = 
  {insns = ret53_inss; terminator = ret53_term}
let ret53_cfg: cfg = (ret53_init_block, [])

let ret53_id: gid = ("return53", 0)
let ret53_type: fty = ([], I64)
let ret53_locals: uid list = []
let ret53_fdecl: fdecl = 
  {fty = ret53_type; param = ret53_locals; cfg = ret53_cfg}

let mk_simple_prog funs: prog = 
  {tdecls = []; extgdecls = []; gdecls = []; extfuns = []; 
   fdecls = funs}
let ret53_prog: prog = mk_simple_prog [(ret53_id, ret53_fdecl)]


let write_to_file (path: string) (contents: string) =
  let oc = open_out path in
  Printf.fprintf oc "%s" contents;
  close_out oc

let _ = write_to_file "ret53.ll" (string_of_prog ret53_prog)
  
(* define i64 @gcd_loop(i64 %a, i64 %b){
    %ap = alloca i64
    store i64 %a, i64* %ap
    %bp = alloca i64
    store i64 %b, i64* %bp
    br label %loop
loop:
    %b1 = load i64, i64* %bp
    %zero = icmp eq i64 %b1, 0
    br i1 %zero, label %after, label %iter
iter:
    %ai = load i64, i64* %ap
    %bi = load i64, i64* %bp
    %m = call i64 @f_mod (i64 %ai, i64 %bi)
    store i64 %m, i64* %bp
    store i64 %bi, i64* %ap
    br label %loop
after:
    %res = load i64, i64* %ap
    ret i64 %res
} *)

let test_cfg: cfg = 
  let bp = ("bp", 3) in
  let b = ("b", 102) in
  let ap = ("ap", 1) in
  let a = ("a", 101) in
  let loop = ("loop", 4) in
  let b1 = ("b1", 5) in
  let zero = ("zero", 6) in
  let iter = ("iter", 7) in
  let after = ("after", 8) in
  let ai = ("ai", 9) in
  let bi = ("bi", 10) in
  let m = ("m", 11) in
  let res = ("res", 12) in
  empty_cfg_builder

  |> add_alloca (ap, I64)
  |> add_insn (None, Store (I64, Id a, Id ap))
  |> add_alloca (bp, I64)
  |> add_insn (None, Store (I64, Id b, Id bp))
  |> term_block (Br loop)

  |> start_block loop
  |> add_insn (Some b1, Load (I64, Id bp))
  |> add_insn (Some zero, Icmp (Eq, I64, Id b1, IConst64 0L))
  |> term_block (Cbr (Id zero, after, iter))
  
  |> start_block iter
  |> add_insn (Some ai, Load (I64, Id ap))
  |> add_insn (Some bi, Load (I64, Id bp))
  |> add_insn (Some m, Binop (SRem, I64, Id ai, Id bi))
  |> add_insn (None, Store (I64, Id m, Id bp))
  |> add_insn (None, Store (I64, Id bi, Id ap))
  |> term_block (Br loop)

  |> start_block after
  |> add_insn (Some res, Load (I64, Id ap))
  |> term_block (Ret (I64, Some (Id res)))
  |> get_cfg

let test_id: gid = ("test", 2)
let test_type: fty = ([I64; I64], I64)
let test_locals: uid list = [("a", 101); ("b", 102)]
let test_fdecl: fdecl = 
  {fty = test_type; param = test_locals; cfg = test_cfg}

let test_prog: prog = mk_simple_prog [(test_id, test_fdecl)]
let _ = write_to_file "test.ll" (string_of_prog test_prog)



(* module type CheckType = sig
  val x: int
  (* val y: int *)
end

module Check: CheckType = struct
  let x = 10
end *)


