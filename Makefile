SHELL:=/bin/bash
CC=gcc
DEBUGFLAGS=-O0 -g
RELEASEFLAGS=-O3
CFLAGS=--std=c99 -march=native
CLIBS=-fopenmp

.PRECIOUS: release* debug*



# Print node tolopogy using likwid-topology.
show_topology:
	module load likwid; \
	likwid-topology -g | less -S



# Compile and run release executable.
release%: test%.c
	$(CC) $(CFLAGS) $(RELEASEFLAGS) $^ -o $@ $(CLIBS)

rrun%: release%
	time ./$^

release_daxpy_lightweight: test_daxpy.c    # Version with cheap for loops.
	$(CC) $(CFLAGS) $(RELEASEFLAGS) $^ -o $@ $(CLIBS)

release_daxpy_heavyweight: test_daxpy.c    # Version with expensive for loops.
	$(CC) $(CFLAGS) $(RELEASEFLAGS) -DUSE_EXPENSIVE_LOOP \
	$^ -o $@ $(CLIBS) -lm

rrun_daxpy%: release_daxpy%
	OMP_NUM_THREADS=1 ./$^
	OMP_NUM_THREADS=16 ./$^



# Compile and run debug executable with Arm Forge.
debug%: test%.c
	$(CC) $(CFLAGS) $(DEBUGFLAGS) $^ -o $@ $(CLIBS)

drun%: debug%
	module load ddt/18.0.2; \
	ddt ./$^


# Generate asm code to look at.
asm%: test%.c
	$(CC) $(CFLAGS) $(RELEASEFLAGS) $^ $(CLIBS) -S -fverbose-asm -masm=intel



# Clean binary and temporary files.
clean:
	rm -rf *~ debug_* release_*
