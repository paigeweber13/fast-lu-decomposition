#include <iostream>

#include "matrix.hpp"
#include "lu_decomp.hpp"

using namespace std;

void test();

int main(){
  test();
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
