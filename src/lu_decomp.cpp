#include "lu_decomp.hpp"

tuple<Matrix, Matrix> lu_factorize(Matrix matrix){
  Matrix l;
  Matrix u;
  return tuple<Matrix, Matrix>(l, u);
}
