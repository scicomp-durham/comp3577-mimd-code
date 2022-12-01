#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

/*
 * Compute daxpy:
 *     z <- alpha*x + y
 * where z, x, y are double-precision n-vectors and
 * alpha is a double-precision scalar.
 */
int main() {

  /* Shared variables. */
  size_t n = 10000000;
  double *x = malloc(n * sizeof *x);
  double *y = malloc(n * sizeof *y);
  double *z = malloc(n * sizeof *z);
  double alpha = 2.23;

  double start_time = omp_get_wtime();
  #pragma omp parallel
  {
    #pragma omp for
    for (int i = 0; i < n; ++i) {
      x[i] = 1.23 * i;
      y[i] = 4.56 * i;
    }

    /* This barrier is unnecessary here. */
    #pragma omp barrier

    #pragma omp for
    for (int i = 0; i < n; ++i) {
      z[i] = alpha*x[i] + y[i];
    }
  }
  double time = omp_get_wtime() - start_time;
  printf("Max threads:  %3d\n", omp_get_max_threads());
  printf("Elapsed time: %.3es\n", time);

  free(x);
  free(y);
  free(z);
}
