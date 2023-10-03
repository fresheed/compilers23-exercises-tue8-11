
let rec gcd_rec a b = 
  if b = 0 then a
  else gcd_rec b (a mod b)

  (* function gcd(a, b)
  while b ≠ 0
      t := b
      b := a mod b
      a := t
  return a   *)

  (* while boolean-condition do
    expression
  done *)

let gcd_loop a b = 
  let ar = ref a in
  let br = ref b in
  while (!br <> 0) do
    let t = !br in
    br := (!ar mod t);
    ar := t
  done;
  !ar
  
let examples = [(10, 10, 10); (5, 10, 5); (15, 10, 5);
                (2, 10, 2); (0, 10, 10); (12, 10, 2);
                (10, 0, 10)]

let check (a, b, res) =
   Printf.printf "GCD(%i, %i):  rec=%i, loop=%i, expected %i\n" 
   a b (gcd_rec a b) (gcd_loop a b) res

let _ = List.iter check examples