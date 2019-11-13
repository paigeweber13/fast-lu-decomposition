#include "matrix.hpp"

Matrix generate_matrix(size_t n){
  Matrix matrix(n);
  
  srand(time(NULL));
  for (size_t i = 0; i < n; i++){
    matrix[i] =
      vector<float, boost::alignment::aligned_allocator<float, 32>>(n);
    for (size_t j = 0; j < n; j++){
      matrix[i][j] = float(rand()) / float(RAND_MAX);
    }
  }

  return matrix;
}
