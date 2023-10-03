#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>  

extern int dolphin_main();

int main(int argc, char *argv[]) {
    dolphin_main();
    return 0;
}


void error_div_by_zero () {
    printf ("Error: division by zero\n");
    exit (1);
}

void print_integer (int64_t x) {
    printf ("%ld\n", x);
}

int64_t read_integer () {
    int64_t value;
    printf("Please enter an integer: ");
    scanf("%" PRId64 "" , &value);
    return value;
}