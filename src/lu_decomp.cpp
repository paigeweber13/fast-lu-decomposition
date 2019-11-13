#include "lu_decomp.hpp"

pair<Matrix, Matrix> lu_factorize(Matrix m){
  Matrix l(m.size());
  Matrix u = m;

  // diagonal 1s
  for (size_t i = 0; i < l.size(); i++){
    l[i] = vector<float, boost::alignment::aligned_allocator<float, 32>>(
      l.size());
    l[i][i] = 1;
  }

  for (size_t j = 0; j < u[0].size(); j++){
    float diag = u[j][j];
    for (size_t i = j+1; i < u.size(); i++){
      // these for loops will do everything UNDER the diagonal
      // accessed in column-major order
      // u[i][j] = x;
      float target = u[i][j];
      float multiplier = -target/diag;
      l[i][j] = -multiplier;
      for (size_t k = 0; k < u[0].size(); k++){
        // when I didn't manually set this to zero, I was getting very, very
        // small numbers (in the order of 10e-8 and 10e-9). I believe this is
        // because of rounding error.

        // alternative: round everything to like 6 decimal places?

        // this has been run through some basic tests and seems to work.
        if(k <= j)
          u[i][k] = 0;
        else
          u[i][k] = u[j][k] * multiplier + u[i][k];
      }
    }
  }

  return pair<Matrix, Matrix>(l, u);
}

bool check_lu_correctness(Matrix input, pair<Matrix, Matrix> lu){
}

bool compare_matrix_with_boost_matrix(Matrix a, ub::matrix<float> b){
  bool same = true;
  size_t num_errors = 0;
  for (size_t i = 0; i < a.size(); ++ i){
    for (size_t j = 0; j < a[0].size(); ++ j){
      if(a[i][j] != b(i, j)){
        same = false;
        cout << "matrices differ at index " << i << ", " << j << ".";
        cout << "a[i][j] = " << a[i][j] << " b[i][j] " << b(i, j) << endl;
        num_errors++;
      }
      if (num_errors > 10) break;
    }
  }
  return same;
}

ub::matrix<float> copy_matrix_to_boost_matrix(Matrix input){
  ub::matrix<float> m(input.size(), input[0].size());
  for (size_t i = 0; i < m.size1 (); ++ i)
    for (size_t j = 0; j < m.size2 (); ++ j)
      m (i, j) = input[i][j];
  return m;
}

