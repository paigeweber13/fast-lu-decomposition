#include <iostream>

#include "generate_test_matrices.hpp"

using namespace std;

int main(){
  auto m = generate_matrix(10);
  for(size_t i = 0; i < m.size(); i++){
    for(size_t j = 0; j < m[0].size(); j++){
      cout << m[i][j] << ", ";
    }
    cout << endl;
  }
}