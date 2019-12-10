# First test
initial model:
 - entries/s flop limit = 425 Giga-entries/second
 - entries/s mem limit = 8.5 Giga-entries/second

initial measurements:
 - best (size 32): 0.019857 Gigaentries/second
 - for large matrix of size 8192: 0.000041 Gigaentries/second

Full results available in experiments/speedtest-basic-cpu.csv. In general,
speed decreases as matrix size increases.

## FMA
this was confirmed to use fused multiply-add. Below is the generated assembly

    # src/lu_decomp.cpp:34:         m[row][col_2] = m[col][col_2] * multiplier + m[row][col_2];
    	.loc 1 34 0
    	vfmadd231sd	(%r9), %xmm0, %xmm1	# *_17, multiplier, tmp235

# Speedup from omp parallel for:
tested a few different places to parallelize. Outer loop and outer loop with
collapse were both good. Collapse was better. 

measurements: 
 - best (size 1024): 0.004818
 - for size 8192: 0.000168

This implementation is MUCH slower for small matricies (n < 512 is faster in
the sequential code) but the biggest size is ~4 times faster

let's make the code choose the sequential version for small values of n

# Vectorizing
Tried to vectorize, performance initially worsened
matrix_size   without vectors   with vectors
256           0.005305          0.001641
512           0.002492          0.001014
1024          0.001347          0.000372
2048          0.000244          0.000153

in this case, was only using vectors every fourth thing number...

wasn't able to get it working for every iteration, even with loadu/storeu

Is there some way to store everything aligned to a 32-byte boundary? even if
that means repeat entries?

each double takes 64 bits, that's 8 bytes

E.G.:
memory address : |0x128 0x136 0x144 0x152 |0x160 0x168 0x176 0x184 |0x192
matrix entry   : |a1,0  a1,1  a1,2  a1,3  |a1,1  a1,2  a1,3  a1,4  |a1,2
(pipes indicate desired alignment)

This would take ~4x the memory.... but is it worth it?

# Store Matrices in column-major order
Don't actually think this will help... Inner loops (that are actually
parallelized) are operated on column by colum in the same row. Therefore,
keeping it row-major should give best locality

# Vectorizing round 2
So the reason we start at the column of the diagonal is because we don't want
to do redundant computation. But vectorizing is going to help more than
removing redundant computation will.

So instead of starting at the diagonal, let's start at the greatest multiple of
4 that is less than the column index.

successfully vectorized

vectorized code is almost identically fast (for sequential) and faster in some
cases, slower in others for parallel

# next steps
 - get csvs of results for 
   - sequential
	 - parallel
	 - sequential vectorized
	 - parallel vectorized
 - run intel vtune on parallel vectorized for comparison
