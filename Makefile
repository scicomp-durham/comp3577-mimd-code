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
	$(CC) $(CFLAGS) $(RELEASEFLAGS) $^ -o $@.bin $(CLIBS)

rrun%: release%
	time ./$^.bin

rrun_daxpy: release_daxpy
	OMP_NUM_THREADS=1 ./release_daxpy.bin
	OMP_NUM_THREADS=16 ./release_daxpy.bin



# Compile and run debug executable with Arm Forge.
debug%: test%.c
	$(CC) $(CFLAGS) $(DEBUGFLAGS) $^ -o $@.bin $(CLIBS)

drun%: debug%
	module load ddt/18.0.2; \
	ddt ./$^.bin


# Generate asm code to look at.
asm%: test%.c
	$(CC) $(CFLAGS) $(RELEASEFLAGS) $^ $(CLIBS) -S -fverbose-asm -masm=intel



# Clean binary files.
clean:
	rm -rf *~ *.bin
