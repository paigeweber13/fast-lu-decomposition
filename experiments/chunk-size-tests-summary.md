# sequential results
schedule type,chunk size,matrix size,time (ms),Gigaentries per second
sequential,0,256,1.235328,0.005305
sequential,0,512,10.518959,0.002492
sequential,0,1024,77.818696,0.001347
sequential,0,2048,1721.990168,0.000244

# best form outer for loop parallelized
 - for matrix size 256, sequential was fastest, regardless of schedule
 - for matrix size 512, sequential was fastest, regardless of schedule
 - for matrix size 1024, schedule(static, 16) outperformed sequential by
   ~140%. Other schedules performed similarly to sequential.
 - for matrix size 2048, schedule(guided, 16) outperformed sequential by a
   factor of ~2.5. Other schedules also outperformed sequential.

# best from inner for loop parallelized
 - in all cases, sequential code outperformed parallel code

# best from collapsed for loops parallelized
 - for matrix size 256, sequential was fastest, regardless of schedule
 - for matrix size 512, schedule(static, 16) outperformed sequential by a
   a factor of ~4.
 - for matrix size 1024, schedule(static, 16) outperformed sequential by a
   a factor of ~3.5.
 - for matrix size 2048, schedule(guided, 32) outperformed sequential by a
   a factor of ~4.
