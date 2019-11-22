#include <iostream>

#include "matrix.hpp"
#include "lu_decomp.hpp"

using namespace std;

void basic_test();
void randomized_tests();

int main(){
  basic_test();
  randomized_tests();
}

void randomized_tests(){
  printf("matrix size,correctly factorized?\n");
  for(size_t i = 2; i < 2500; i *= 2){
    auto m = generate_matrix(i);
    auto m_ublas = copy_matrix_to_boost_matrix(m);

    lu_factorize(m);

    auto correct = check_lu_correctness(m_ublas, m);
    printf("%lu,%i\n", i, correct);
  }
}

void basic_test(){
  Matrix m = {{1, 1, -1},
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
