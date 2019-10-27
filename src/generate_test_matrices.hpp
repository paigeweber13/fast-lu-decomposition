#pragma once

#include <boost/align/aligned_allocator.hpp>
#include <stdlib.h>
#include <time.h>
#include <vector>

using namespace std;

// note: a matrix of floats of size 32e9 will require about 128GB to represent
// in memory

vector<vector<
  float, boost::alignment::aligned_allocator<float, 32> 
>> generate_matrix(size_t n);
