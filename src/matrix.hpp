#pragma once

#include <boost/align/aligned_allocator.hpp>
#include <time.h>
#include <vector>

using namespace std;

// note: a matrix of floats of size 32e9 will require about 128GB to represent
// in memory

using Matrix = std::vector<std::vector<
                 float, boost::alignment::aligned_allocator<float, 32> >>;
Matrix generate_matrix(size_t n);
