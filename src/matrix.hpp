#pragma once

#include <boost/align/aligned_allocator.hpp>
#include <boost/numeric/ublas/lu.hpp>
#include <iomanip>
#include <iostream>
#include <time.h>
#include <tuple>
#include <vector>

using namespace std;
namespace ub = boost::numeric::ublas;

// note: a matrix of floats of size 32e9 will require about 128GB to represent
// in memory

using Matrix = std::vector<std::vector<
                 float, boost::alignment::aligned_allocator<float, 32> >>;
bool compare_matrices(Matrix a, Matrix b);
bool compare_matrix_with_boost_matrix(Matrix a, ub::matrix<float> b);
ub::matrix<float> copy_matrix_to_boost_matrix(Matrix input);
Matrix generate_matrix(size_t n);
void print_matrix(Matrix m);
void print_matrix(ub::matrix<float> m);
