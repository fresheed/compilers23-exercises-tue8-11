#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h> 

extern int f_mod(int a, int b);
extern int gcd_rec(int a, int b);
extern int gcd_loop(int a, int b);

int main(int argc, char *argv[]) {
/*     if (argc != 3) {
        printf("Please call this program with two arguments: %s <a> <b>\n", argv[0]);
        return 1;
    }

    int a = atoi(argv[1]);
    int b = atoi(argv[2]);
 */
    // int result = f_mod(10, 0);

    int As[] = {10, 5, 15, 2, 0, 12};
    int Bs[] = {10, 10, 10, 10, 10, 0};
    int exps[] = {10, 5, 5, 2, 10, 12};

    for (int i = 0; i < 6; i++){
        int a = As[i], b = Bs[i], exp = exps[i];
        int res_rec = gcd_rec(a, b), res_loop = gcd_loop(a, b);
        printf("GCD(%i, %i): rec = %i, loop = %i, expected %i\n", a, b, res_rec, res_loop, exp);
    }


    // printf("%d\n", result);

    return 0;
}

void error_div_by_zero () {
    printf ("Error: division by zero\n");
    exit (1);
}

void print_integer (int64_t x) {
    printf ("%d\n", x);
}

int64_t read_integer () {
    int64_t value;
    printf("Please enter an integer: ");
    scanf("%" PRId64 "" , &value);
    return value;
}