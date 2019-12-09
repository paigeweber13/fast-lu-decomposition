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

# Store Matrices in column-major order
