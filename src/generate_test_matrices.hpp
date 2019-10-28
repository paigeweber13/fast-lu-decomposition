#pragma once

#include <stdlib.h>
#include <time.h>
#include <vector>

#include "matrix.hpp"

using namespace std;

// note: a matrix of floats of size 32e9 will require about 128GB to represent
// in memory

Matrix generate_matrix(size_t n);
