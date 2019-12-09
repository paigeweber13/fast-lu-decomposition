#include "lu_decomp.hpp"

void lu_factorize(Matrix &m, omp_sched_t sched_type,
                           size_t chunk_size){
  // todo: start using this:
  // const size_t threshold = 512;
  // if (m.size() < threshold){
  //   lu_factorize_sequential(m);
  // }
  // else {
  //   lu_factorize_parallel(m, sched_type, chunk_size);
  // }
  lu_factorize_sequential(m);
  // lu_factorize_parallel(m, sched_type, chunk_size);
}

void lu_factorize_sequential(Matrix &m){
  double diag, target, multiplier;
  size_t n = m.size();
  __m256d a, multiplier_vector, c, result;

  // each column depends on the column to the left
  for (size_t col = 0; col < n; col++){
    // for each column
    diag = m[col][col];
    for (size_t row = col+1; row < n; row++){
      // for each row under the diagonal

      target = m[row][col];
      multiplier = -target/diag;
      multiplier_vector = _mm256_broadcast_sd(&multiplier);
      for (size_t col_2 = col; col_2 < n; ){
        // for each column (again) starting at the diagonal and moving right
        if (col_2 % 4 == 0){
          // printf("n: %lu, col_2 %lu, n-col_2 %lu\n", n, col_2, n-col_2);
          // vector code
          a = _mm256_load_pd(&m[col][col_2]);
          c = _mm256_load_pd(&m[row][col_2]);
          // fmadd causes segfault
          // happens as soon as col goes to 1
          // must be because it's not aligned right??? array as a whole is
          // aligned but not each individual double?
          result = _mm256_fmadd_pd(a, multiplier_vector, c);
          _mm256_store_pd(&m[row][col_2], result);
          col_2 += 4;
        }
        else {
          m[row][col_2] = m[col][col_2] * multiplier + m[row][col_2];
          col_2++;
        }
      }

      m[row][col] = -multiplier;
    }
  }
}

void lu_factorize_parallel(Matrix &m, omp_sched_t sched_type,
                           size_t chunk_size){
  double diag, target, multiplier;

  // each column depends on the column to the left
  for (size_t col = 0; col < m[0].size(); col++){
    // for each column
    diag = m[col][col];
    #pragma omp parallel 
    {
    omp_set_schedule(sched_type, chunk_size);
    #pragma omp for collapse(1) schedule(runtime)
    for (size_t row = col+1; row < m.size(); row++){
      // for each row under the diagonal
      // these can be done independently WITHIN THIS FOR LOOP

      target = m[row][col];
      multiplier = -target/diag;
      for (size_t col_2 = col; col_2 < m[0].size(); col_2++){
        // for each column (again) starting at the diagonal and moving right
        // these can be done independently
        m[row][col_2] = m[col][col_2] * multiplier + m[row][col_2];
      }

      m[row][col] = -multiplier;
    }
    }
  }
}

bool check_lu_correctness(ub::matrix<double> input, Matrix lu){
  ub::lu_factorize(input);
  return compare_matrix_with_boost_matrix(lu, input);
}
