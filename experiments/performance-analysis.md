# First test
initial model:
 - entries/s flop limit = 425 Giga-entries/second
 - entries/s mem limit = 8.5 Giga-entries/second

initial measurements:
 - best (size 32): 0.019857 Gigaentries/second
 - for large matrix of size 8192: 0.000041 Gigaentries/second

Full results available in experiments/speedtest-basic-cpu.csv. In general,
speed decreases as matrix size increases.

# Speedup from omp parallel for:
tested a few different places to parallelize. Outer loop and outer loop with
collapse were both good. Collapse was better. 

measurements: 
 - best (size ):
 - for size 8192:
