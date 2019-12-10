#pragma once

#include <boost/numeric/ublas/lu.hpp>
#include <omp.h>
#include <tuple>

#include "matrix.hpp"

using namespace std;
namespace ub = boost::numeric::ublas;

void lu_factorize(Matrix &m, omp_sched_t sched_type, size_t chunk_size);
void lu_factorize_sequential(Matrix &m);
void lu_factorize_parallel(Matrix &m, omp_sched_t sched_type,
                           size_t chunk_size);
bool check_lu_correctness(ub::matrix<double> input, Matrix lu);
