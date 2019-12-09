#include "lu_decomp.hpp"

void lu_factorize(Matrix &m, omp_sched_t sched_type, size_t chunk_size){
  double diag, target, multiplier;

  // each column depends on the column to the left
  for (size_t j = 0; j < m[0].size(); j++){
    diag = m[j][j];
    #pragma omp parallel 
    {
    omp_set_schedule(sched_type, chunk_size);
    #pragma omp for collapse(1) schedule(runtime)
    for (size_t i = j+1; i < m.size(); i++){
      // these for loops will do everything UNDER the diagonal
      // accessed in column-major order

      target = m[i][j];
      multiplier = -target/diag;
      for (size_t k = j; k < m[0].size(); k++){
        m[i][k] = m[j][k] * multiplier + m[i][k];
      }

      m[i][j] = -multiplier;
    }
    }
  }
}

bool check_lu_correctness(ub::matrix<double> input, Matrix lu){
  ub::lu_factorize(input);
  return compare_matrix_with_boost_matrix(lu, input);
}
