#include <iomanip>
#include <iostream>

#include "generate_test_matrices.hpp"
#include "lu_decomp.hpp"

using namespace std;

void test();
bool compare_matrices(Matrix a, Matrix b);

int main(){
  test();
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

void test(){
  auto m = generate_matrix(8);
  cout << "original matrix:" << endl;
  print_matrix(m);

  auto lu = lu_factorize(m);
  auto l = lu.first;
  auto u = lu.second;
  cout << "lower diagonal:" << endl;
  print_matrix(l);
  cout << "upper diagonal:" << endl;
  print_matrix(u);


  m = {{1, 1, -1},
       {1, -2, 3},
       {2, 3, 1}};
  Matrix expected_l = {{1, 0, 0},
                       {1, 1, 0},
                       {2, -1./3., 1}};
  Matrix expected_u = {{1, 1, -1},
                       {0, -3, 4},
                       {0, 0, 13./3.}};
  cout << "original matrix:" << endl;
  print_matrix(m);

  lu = lu_factorize(m);
  l = lu.first;
  u = lu.second;
  cout << "lower diagonal:" << endl;
  print_matrix(l);
  cout << "upper diagonal:" << endl;
  print_matrix(u);
  cout << "result == expected?" << endl;
  cout << "lower: " << compare_matrices(l, expected_l) << " ";
  cout << "upper: " << compare_matrices(u, expected_u) << endl;
}
