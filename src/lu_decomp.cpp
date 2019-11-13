#include "lu_decomp.hpp"

void lu_factorize(Matrix &m){
  float diag, target, multiplier;

  for (size_t j = 0; j < m[0].size(); j++){
    diag = m[j][j];
    for (size_t i = j+1; i < m.size(); i++){
      // these for loops will do everything UNDER the diagonal
      // accessed in column-major order

      target = m[i][j];
      multiplier = -target/diag;
      m[i][j] = -multiplier;

      for (size_t k = j; k < m[0].size(); k++){
        // this for loop will do everything above the diagonal for the current
        // row
        m[i][k] = m[j][k] * multiplier + m[i][k];
      }
    }
  }
}

bool check_lu_correctness(ub::matrix<float> input, Matrix lu){
  ub::lu_factorize(input);
  return compare_matrix_with_boost_matrix(lu, input);
}
