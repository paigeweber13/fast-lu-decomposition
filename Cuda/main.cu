/* Standard C++ Header Files */
#include <chrono>
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <ctime>



/* Device Functions Declarations Called By Host */
__global__ void luDecomposition(float *, const float *, const int32_t *, const int32_t *);



/* Device Functions Declarations Called By Device */



/* Host Functions Declarations Called By Host */
__host__ void generateMatrixData(const double *, const int32_t *);
__host__ void printMatrix(const double *, const int32_t *);



/* Start Of Program Execution */
int main(int argc, char **argv)
{
  if(argc < 4) { // Cause why not
    fprintf(stderr, "\nERROR: usage: %s <n>\n\t<n>: matrix dimension\n", argv[0]);
    exit(1);
  }

  srand(time(0)); // Seed randomizer

  // Open Cuda Error Output Stream
  FILE *cudaerr = fopen("cuda_error.txt", "w");
  if(cudaerr == NULL) {
    fprintf(cudaerr, "ERROR: Cuda Error File Could Not Be Opened!");
    exit(2);
  }

  // Parse Command Line
  int32_t dimension = atoi(argv[1]);

  // Matrix data
  n = dimension * dimension;

  // Allocate Host Data
  double *matrix = calloc(n, sizeof(double));
  double *upperMatrix = calloc(n, sizeof(double));
  double *lowerMatrix = calloc(n, sizeof(double));

  // Generate Matrix data 
  generateMatrixData(matrix, &n);
  #if DEBUG == 1
    printMatrix(matrix, dimension);
  #endif

  // Allocate Device Data
  double *d_matrix;
  double *d_upperMatrix;
  double *d_lowerMatrix;
  cudaMalloc((void **)&d_matrix, sizeof(double) * n);
  fprintf(cudaerr, "Allocate d_matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMalloc((void **)&d_upperMatrix, sizeof(double) * n);
  fprintf(cudaerr, "Allocate d_upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMalloc((void **)&d_lowerMatrix, sizeof(double) * n);
  fprintf(cudaerr, "Allocate d_lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));

  // Start Timer
  std::chrono::time_point<std::chrono::steady_clock> start = std::chrono::steady_clock::now();

  // Copy Host Data To Device Memory
  cudaMemcpy(d_matrix, matrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy array to d_matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(d_upperMatrix, upperMatrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy poly to d_upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(d_lowerMatrix, lowerMatrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy poly to d_lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));

  polynomialExpansion<<<(n+block-1)/block,block>>>(d_array, d_poly, d_n, d_degree);
  cudaDeviceSynchronize();
  fprintf(cudaerr, "Synchronize after polynomial expansion: %s\n", cudaGetErrorString(cudaGetLastError()));

  // Copy Device Data to Host Memory
  cudaMemcpy(array, d_matrix, sizeof(float) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_matrix to array: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(poly, d_upperMatrix, sizeof(float) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_upperMatrix to poly: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(poly, d_lowerMatrix, sizeof(float) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_lowerMatrix to poly: %s\n", cudaGetErrorString(cudaGetLastError()));

  // End Timer
  std::chrono::time_point<std::chrono::steady_clock> end = std::chrono::steady_clock::now();
  std::chrono::duration<double> time = end - start;

  // Deallocate Device Data
  cudaFree(d_n);
  fprintf(cudaerr, "Free d_n: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaFree(d_degree);
  fprintf(cudaerr, "Free d_degree: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaFree(d_array);
  fprintf(cudaerr, "Free d_array: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaFree(d_poly);
  fprintf(cudaerr, "Free d_poly: %s\n", cudaGetErrorString(cudaGetLastError()));

  // Print Output
  fprintf(stdout, "\nValue: %.9f\n", array[0]);
  fprintf(stdout, "\nTime: %14.9f\n", time.count());

  // Deallocate Host Data
  delete [] array;
  delete [] poly;

  // Close Cuda Error Output Stream
  fclose(cudaerr);

  return 0;
}



/* Host To Device Function Definitions */

__global__ void polynomialExpansion(float *array, const float *poly, const int32_t *n, const int32_t *degree)
{
  int32_t index = threadIdx.x + blockIdx.x * blockDim.x;
  //printf("Block ID: %4d | Block Dim: %4d | PE Index:  %4d\n", blockIdx.x, blockDim.x, index);
  if(index < *n) {
    //printf("array: %f\n", array[index]);
    array[index] = polynomial(&array[index], &poly[index], degree);
    //printf("array: %f\n", array[index]);
  }

  return;
}



/* Host To Host Function Definitions */

__host__ generateMatrixData(const double *matrix, const int32_t *n)
{
  for(int32_t i = 0; i < n; ++i) {
    #if DEBUG == 1
      matrix[i] = rand() % 99 + 1;
    #else
      matrix[i] = rand() % 999999 + 1;
    #endif
  }
 
  return;
}

__host__ printMatrix(const double *matrix, const int32_t *dimension)
{
  fprintf(stdout, "\nOriginal Matrix:\n");
  for(int32_t i = 0; i < dimension; ++i) {
    for(int32_t j = 0; j < dimension; ++j) {
      fprintf(stdout, "%f ", matrix[i*dimension+j]);
    }
    fprintf(stdout, "\n"_'
  }
  
  return;
}





/* Device To Device Function Definitions */






