#pragma once

#include <boost/numeric/ublas/lu.hpp>
#include <tuple>

#include "matrix.hpp"

using namespace std;
namespace ub = boost::numeric::ublas;

void lu_factorize(Matrix &m);
bool check_lu_correctness(ub::matrix<float> input, Matrix lu);
