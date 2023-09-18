/* save this as main.c */
#include <stdio.h>
#include <stdlib.h>

extern int f_mod(int a, int b);
extern int gcd_rec(int a, int b);
extern int gcd_loop(int a, int b);


int gcd_rec_C(int a, int b){
    if (b == 0){ 
        return a;
    } else {
        return gcd_rec_C(b, a % b);
    }
}


int main(int argc, char *argv[]) {
    // if (argc != 3) {
    //     printf("Please call this program with two arguments: %s <a> <b>\n", argv[0]);
    //     return 1;
    // }

    // int a = atoi(argv[1]);
    // int b = atoi(argv[2]);

    // int result = f_mod(a, b);
    // int result = gcd_rec(a, b);
    int As[] = {0, 5, 10, 15, 20};
    int Bs[] = {10, 10, 10, 10};

    for (int i = 0; i < 5; i++){
        int a = As[i], b = Bs[i];
        int grL = gcd_rec(a, b);
        int glL = gcd_loop(a, b);
        int grC = gcd_rec_C(a, b);
        printf("GCD(%i, %i) = C: {%i}, LLVM(rec): {%i}, LLVM(loop): {%i}\n", a, b, grC, grL, glL);
    }

    // printf("%d\n", result);

    return 0;
}

int error_div_by_zero () {
    printf ("Error: division by zero\n");
    exit (1);
}
