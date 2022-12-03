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

rrun_daxpy: release_daxpy
	OMP_NUM_THREADS=1 ./release_daxpy
	OMP_NUM_THREADS=16 ./release_daxpy



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
