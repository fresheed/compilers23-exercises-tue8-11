declare void @error_div_by_zero()

; define i64 @f_mod(i64 %a, i64 %b) {
;     %m = srem i64 %a, %b
;     ret i64 %m
; }

define i64 @f_mod(i64 %a, i64 %b) {
    %z = icmp eq i64 %b, 0
    br i1 %z, label %zero, label %nzero
zero:
    call void @error_div_by_zero()
    unreachable
nzero:
    %d = sdiv i64 %a, %b
    %p = mul i64 %b, %d
    %m = sub i64 %a, %p
    ret i64 %m
}


define i64 @gcd_rec(i64 %a, i64 %b) {
    %z = icmp eq i64 %b, 0
    br i1 %z, label %zero, label %nzero
zero:
    ret i64 %a
nzero:
    %r = call i64 @f_mod (i64 %a, i64 %b)
    %g = call i64 @gcd_rec(i64 %b, i64 %r)
    ret i64 %g
}


define i64 @gcd_loop(i64 %a, i64 %b){
    %az = icmp eq i64 %a, 0
    br i1 %az, label %ret_b, label %check_a
ret_b:
    ret i64 %b
check_a:
    %bz = icmp eq i64 %b, 0
    br i1 %bz, label %ret_a, label %normal
ret_a:
    ret i64 %a
normal:
    %ap = alloca i64
    %bp = alloca i64
    store i64 %a, i64* %ap
    store i64 %b, i64* %bp
    br label %pre_loop
pre_loop:
    %av = load i64, i64* %ap
    %bv = load i64, i64* %bp   
    %c = icmp eq i64 %av, %bv
    br i1 %c, label %fin, label %loop
loop:
    %ga = icmp sgt i64 %av, %bv
    br i1 %ga, label %decr_a, label %decr_b
decr_a:
    %a2 = sub i64 %av, %bv
    store i64 %a2, i64* %ap
    br label %pre_loop
decr_b:
    %b2 = sub i64 %bv, %av
    store i64 %b2, i64* %bp
    br label %pre_loop
fin:
    ret i64 %av
}