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
  auto m_ublas = copy_matrix_to_boost_matrix(m);
  cout << "original matrix:" << endl;
  print_matrix(m);

  lu_factorize(m);
  cout << "lu factorized:" << endl;
  print_matrix(m);

  cout << "correctly factorized? " << check_lu_correctness(m_ublas, m) << endl;


  m = {{1, 1, -1},
       {1, -2, 3},
       {2, 3, 1}};
  Matrix expected_lu = {{1, 1, -1},
                        {1, -3, 4},
                        {2, -1./3., 13./3.}};
  cout << "original matrix:" << endl;
  print_matrix(m);

  lu_factorize(m);
  cout << "lu factorized:" << endl;
  print_matrix(m);
  cout << "result == expected? " << compare_matrices(m, expected_lu) << endl;
}
