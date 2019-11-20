#include "matrix.hpp"

Matrix generate_matrix(size_t n){
  Matrix matrix(n);
  
  srand(time(NULL));
  for (size_t i = 0; i < n; i++){
    matrix[i] =
      vector<double, boost::alignment::aligned_allocator<double, 32>>(n);
    for (size_t j = 0; j < n; j++){
      matrix[i][j] = double(rand()) / double(RAND_MAX);
    }
  }

  return matrix;
}

bool compare_matrices(Matrix a, Matrix b){
  if(a.size() != b.size() || a[0].size() != b[0].size())
    return false;

  for(size_t i = 0; i < a.size(); i++){
    for(size_t j = 0; j < a[0].size(); j++){
      if(a[i][j] != b[i][j]){
        // cout << "a[i][j]: " << a[i][j] << " b[i][j]: " << b[i][j] << endl;
        return false;
      }
    }
  }
  return true;
}

bool compare_matrix_with_boost_matrix(Matrix a, ub::matrix<double> b){
  bool same = true;
  size_t num_errors = 0;
  double threshold_percent = 0.1;
  double threshold, diff;

  for (size_t i = 0; i < a.size(); ++ i){
    for (size_t j = 0; j < a[0].size(); ++ j){
      diff = abs(a[i][j] - b(i, j));
      threshold = abs(a[i][j] * threshold_percent);
      if(diff > threshold){
        same = false;
        cout << "matrices differ at index " << i << ", " << j << ".";
        cout << "a[i][j] = " << a[i][j] << " b[i][j] " << b(i, j) << endl;
        cout << "difference: " << diff << endl;
        cout << "threshold: " << threshold << endl;
        num_errors++;
      }
      if (num_errors > 10) break;
    }
  }
  return same;
}

ub::matrix<double> copy_matrix_to_boost_matrix(Matrix input){
  ub::matrix<double> m(input.size(), input[0].size());
  for (size_t i = 0; i < m.size1 (); ++ i)
    for (size_t j = 0; j < m.size2 (); ++ j)
      m (i, j) = input[i][j];
  return m;
}

void print_matrix(Matrix m){
  for(size_t i = 0; i < m.size(); i++){
    for(size_t j = 0; j < m[0].size(); j++){
      cout << setw(10) << setprecision(4) << m[i][j] << ", ";
    }
    cout << endl;
  }
  cout << endl;
}

void print_matrix(ub::matrix<double> m){
  for(size_t i = 0; i < m.size1(); i++){
    for(size_t j = 0; j < m.size2(); j++){
      cout << setw(10) << setprecision(4) << m(i, j) << ", ";
    }
    cout << endl;
  }
  cout << endl;
}
