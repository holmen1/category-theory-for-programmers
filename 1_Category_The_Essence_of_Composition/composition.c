#include <stdio.h>

// takes two functions as arguments and returns a function that is their composition
int compose(int (*g)(int), int (*f)(int), int x) { return g(f(x)); }

int add1(int x) { return x + 1; }
int mul2(int x) { return x * 2; }

int add1_mul2(int x) { return compose(&add1, &mul2, x); }
int mul2_add1(int x) { return compose(&mul2, &add1, x); }

int main(void) {
  int x = 3 ;
  printf("add1_mul2(%d) = %d\n", x, add1_mul2(3));
  printf("mul2_add1(%d) = %d\n", x, mul2_add1(3));

  return 0;
}
