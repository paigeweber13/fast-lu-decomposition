#include <chrono>
#include <iostream>
#include <omp.h>

#include "matrix.hpp"
#include "lu_decomp.hpp"

using namespace std;

#define DEFAULT_CHUNK_SIZE 32
#define DEFAULT_SCHED_TYPE omp_sched_static

const double nanoseconds_to_seconds = 1e-9;
const double nanoseconds_to_milliseconds = 1e-6;

void basic_test();
void randomized_tests();
void time_tests();
void chunk_size_tests();

int main(){
  // basic_test();
  randomized_tests();
  time_tests();
  // chunk_size_tests();
}

void time_tests(){
  printf("matrix size,time (ms),Gigaentries per second\n");
  for(size_t i = 2; i < 1e4; i *= 2){
    auto m = generate_matrix(i);

    auto start_time = chrono::high_resolution_clock::now();
    lu_factorize(m, DEFAULT_SCHED_TYPE, DEFAULT_CHUNK_SIZE);
    auto end_time = chrono::high_resolution_clock::now();
    auto raw_duration = chrono::duration_cast<chrono::nanoseconds>(
        end_time - start_time).count();

    double duration = double(raw_duration) * nanoseconds_to_milliseconds;
    double duration_seconds = double(raw_duration) * nanoseconds_to_seconds;
    printf("%lu,%f,%f\n", i, duration, double(i*i)/(10e9*duration_seconds));
  }
}

void chunk_size_tests(){
  printf("schedule type,chunk size,matrix size,time (ms),"
         "Gigaentries per second\n");

  omp_sched_t scheduling_types[3] = {
    omp_sched_static,
    omp_sched_dynamic,
    omp_sched_guided
    };
  string scheduling_type_names[3] = {"static", "dynamic", "guided"};
  const size_t num_iterations = 10;

  for(size_t i = 0; i < num_iterations; i++){
    printf("Doing iteration %lu", i);
    for(size_t sched_i = 0; sched_i < 3; sched_i++){
      for(size_t mat_size = 256; mat_size < 2050; mat_size*=2){
        for(size_t chunk_size = 4; chunk_size < 65; chunk_size++){
          auto m = generate_matrix(mat_size);

          auto start_time = chrono::high_resolution_clock::now();
          lu_factorize(m, scheduling_types[sched_i], chunk_size);
          auto end_time = chrono::high_resolution_clock::now();
          auto raw_duration = chrono::duration_cast<chrono::nanoseconds>(
              end_time - start_time).count();

          double duration = double(raw_duration) * nanoseconds_to_milliseconds;
          double duration_seconds = double(raw_duration) * nanoseconds_to_seconds;
          printf("%s,%lu,%lu,%f,%f\n", 
                 scheduling_type_names[sched_i].c_str(),
                 chunk_size, mat_size, duration, 
                 double(mat_size*mat_size)/(10e9*duration_seconds));
        }
      }
    }
  }
}

void randomized_tests(){
  printf("matrix size,correctly factorized?\n");
  for(size_t i = 2; i < 550; i *= 2){
    auto m = generate_matrix(i);
    auto m_ublas = copy_matrix_to_boost_matrix(m);

    lu_factorize(m, DEFAULT_SCHED_TYPE, DEFAULT_CHUNK_SIZE);

    auto correct = check_lu_correctness(m_ublas, m);
    printf("%lu,%i\n", i, correct);
  }
}

void basic_test(){
  Matrix m = {{1, 1, -1},
       {1, -2, 3},
       {2, 3, 1}};
  Matrix expected_lu = {{1, 1, -1},
                        {1, -3, 4},
                        {2, -1./3., 13./3.}};
  cout << "original matrix:" << endl;
  print_matrix(m);

  lu_factorize(m, DEFAULT_SCHED_TYPE, DEFAULT_CHUNK_SIZE);
  cout << "lu factorized:" << endl;
  print_matrix(m);
  cout << "result == expected? " << compare_matrices(m, expected_lu) << endl;
}
