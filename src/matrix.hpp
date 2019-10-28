#pragma once

#include <boost/align/aligned_allocator.hpp>
#include <vector>

using Matrix = std::vector<std::vector<
                 float, boost::alignment::aligned_allocator<float, 32> >>;