# OpenMP examples for instruction-level parallelisation

These examples showcase some features of OpenMP for instruction-level parallelism. Codes with the `_bug` suffix should not work, those with the `_bad` and `_good` suffixes are examples of bad and good practices, respectively.

## Summary of codes

Codes are independent of each other, unless otherwise stated, but I suggest that you look at them in this order.

+ `test_omp_functions.c`: Print OpenMP parameters using OpenMP library routines. This codes showcases functions that might be useful for debugging. Running this code can also help you check that OpenMP is configured correctly on the machine you are using.

+ `test_parallel_region.c`: Print from within a parallel section. The code shows interleaved execution and lack of reproducibility.

+ `test_logger_bug.c`: Code that hangs because a `for` loop within a parallel section is not reached by all threads. **Try to fix it!**

+ `test_logger_single_bug.c`: Code that hangs because of an incorrect use of the `#pragma omp single` within a parallel section. **Try to fix it!**

+ `test_daxpy.c`: Compute daxpy *z ← α x + y* where *z*, *x*, and *y* are double-precision *n*-vectors and *α* is a double-precision scalar. The code features shared variables, an **unnecessary** `omp barrier`, and a `for` within a `parallel` section.

+ `test_ddot_bug.c`: Compute the inner product *z ← x · y* where *z*, *x*, and *y* are double-precision *n*-vectors. Data races prevent this code from computing the correct result.

+ `test_ddot_atomic_bad.c`: This attempt to fix `test_ddot_atomic_bug.c` using atomics computes the correct result but is unbearably slow. This is a bad use of atomics.

+ `test_ddot_visibility_bug.c`: This attempt to fix `test_ddot_atomic_bug.c` using atomics follows good practices, but still computes an incorrect result because of data races. **Try to fix it!**

+ `test_ddot_atomic_good.c`: This attempt to fix `test_ddot_atomic_bug.c` using atomics computes the correct result and is orders of magnitude faster than `test_ddot_atomic_bad.c`. This is achieved by using atomics sparingly.

+ `test_ddot_reduce.c`: This attempt to fix `test_ddot_atomic_bug.c` using a reduction operation computes the correct result and has good performance.

## Compiling and running the code

You can compile these examples using the `make` command—see the `Makefile` for details. Most targets use wildcards, and you should replace the `%` in the target with the name of the C file you want to compile/and or run, without the `test_` prefix and without the `.c` suffix.

### Example

Taking the file `test_ddot_bug.c` as a model, you can run the following:

```console
>> # Compile code with optimizations.
>> make release_test_ddot_bug
>>
>> # Compile code as above, and time a single run using time.
>> make rrun_test_ddot_bug
>>
>> # Compile code without optimizations and with bebugging symbols.
>> make debug_test_ddot_bug
>>
>> # Open code in Arm Forge (on Hamilton).
>> make drun_test_ddot_bug
```

The only exception to this is the code `test_daxpy.c`, since
```console
>> make rrun_daxpy
```
runs the code produced by
```console
>> make release_daxpy
```
twice, once with 1 and once with 16 OpenMP threads. Unlike all other cases, the runtime is computed using the `omp_get_wtime()` function within the C code, rather than the Unix command `time`.