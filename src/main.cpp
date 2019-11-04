#include <iostream>

#include "generate_test_matrices.hpp"
#include "lu_decomp.hpp"

using namespace std;

void test();

int main(){
  test();
}

void print_matrix(Matrix m){
  for(size_t i = 0; i < m.size(); i++){
    for(size_t j = 0; j < m[0].size(); j++){
      cout << m[i][j] << ", ";
    }
    cout << endl;
  }
}

void test(){
  auto m = generate_matrix(10);
  print_matrix(m);

  auto lu = lu_factorize(m);
  auto l = lu.first;
  auto u = lu.second;
  print_matrix(l);
  print_matrix(u);
}
