#pragma once

#include <boost/numeric/ublas/lu.hpp>
#include <tuple>

#include "matrix.hpp"

using namespace std;
namespace ub = boost::numeric::ublas;

pair<Matrix, Matrix> lu_factorize(Matrix);
bool check_lu_correctness(Matrix input, pair<Matrix, Matrix> lu);
