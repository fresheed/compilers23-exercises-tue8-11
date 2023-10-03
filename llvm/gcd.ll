declare void @error_div_by_zero()

; assume that a>=0, b>=0
define i64 @f_mod_rec(i64 %a, i64 %b){
    %d = icmp eq i64 %b, 0
    br i1 %d, label %b0, label %bn0
b0:
    call void @error_div_by_zero()
    unreachable
bn0:
    ; compare: a<b
    %c = icmp slt i64 %a, %b
    ; jump depending on (a<b) result
    br i1 %c, label %lt, label %ge
lt:
    ret i64 %a
ge:
    ; a % b = (a-b) % b if a>=b
    %a1 = sub i64 %a, %b
    %r = call i64 @f_mod(i64 %a1, i64 %b)
    ret i64 %r
}

define i64 @f_mod(i64 %a, i64 %b){
    %d = icmp eq i64 %b, 0
    br i1 %d, label %b0, label %bn0
b0:
    call void @error_div_by_zero()
    unreachable
bn0:
    %q = sdiv i64 %a, %b
    %p = mul i64 %b, %q
    %r = sub i64 %a, %p
    ret i64 %r
}

define i64 @gcd_rec(i64 %a, i64 %b){
    %zero = icmp eq i64 %b, 0
    br i1 %zero, label %b0, label %bn0

b0: 
    ret i64 %a
bn0:
    %a1 = call i64 @f_mod (i64 %a, i64 %b)
    %r = call i64 @gcd_rec (i64 %b, i64 %a1)
    ret i64 %r
}

define i64 @gcd_loop(i64 %a, i64 %b){
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
}