/* Standard C++ Header Files */
#include <chrono>
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <ctime>



/* Device Functions Declarations Called By Host */
__global__ void luDecomposition();



/* Device Functions Declarations Called By Device */



/* Host Functions Declarations Called By Host */
__host__ void generateMatrixData(double *, const int *);
__host__ void printMatrix(const double *, const int *);



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
  int dimension = atoi(argv[1]);

  // Matrix data
  int n = dimension * dimension;

  // Allocate Host Data
  double *matrix = (double *)calloc(n, sizeof(double));
  double *upperMatrix = (double *)calloc(n, sizeof(double));
  double *lowerMatrix = (double *)calloc(n, sizeof(double));

  // Generate Matrix data 
  generateMatrixData(matrix, &n);
  printMatrix(matrix, &dimension);

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

  // Cuda Stuff
  int block = 256;

  // Start Timer
  std::chrono::time_point<std::chrono::steady_clock> start = std::chrono::steady_clock::now();

  // Copy Host Data To Device Memory
  cudaMemcpy(d_matrix, matrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy matrix to d_matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(d_upperMatrix, upperMatrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy upperMatrix to d_upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(d_lowerMatrix, lowerMatrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy lowerMatrix to d_lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));

  //luDecomposition<<<(n+block-1)/block,block>>>();
  cudaDeviceSynchronize();
  fprintf(cudaerr, "Synchronize after LU Decomposition: %s\n", cudaGetErrorString(cudaGetLastError()));

  // Copy Device Data to Host Memory
  cudaMemcpy(matrix, d_matrix, sizeof(double) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_matrix to matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(upperMatrix, d_upperMatrix, sizeof(double) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_upperMatrix to upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(lowerMatrix, d_lowerMatrix, sizeof(double) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_lowerMatrix to lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));

  // End Timer
  std::chrono::time_point<std::chrono::steady_clock> end = std::chrono::steady_clock::now();
  std::chrono::duration<double> time = end - start;

  // Deallocate Device Data
  cudaFree(d_matrix);
  fprintf(cudaerr, "Free d_matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaFree(d_upperMatrix);
  fprintf(cudaerr, "Free d_upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaFree(d_lowerMatrix);
  fprintf(cudaerr, "Free d_lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));

  // Print Time
  fprintf(stdout, "\n%7d\t%14.9f\n", n, time.count());

  // Deallocate Host Data
  free(matrix);
  free(upperMatrix);
  free(lowerMatrix);

  // Close Cuda Error Output Stream
  fclose(cudaerr);

  return 0;
}



/* Host To Device Function Definitions */

__global__ void luDecomposition()
{
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  //printf("Block ID: %4d | Block Dim: %4d | PE Index:  %4d\n", blockIdx.x, blockDim.x, index);

  return;
}



/* Host To Host Function Definitions */

__host__ void generateMatrixData(double *matrix, const int *n)
{
  for(int i = 0; i < *n; ++i) {
    matrix[i] = rand() % 99 + 1;
  }
 
  return;
}

__host__ void printMatrix(const double *matrix, const int *dimension)
{
  fprintf(stdout, "\nOriginal Matrix:\n");
  for(int i = 0; i < *dimension; ++i) {
    for(int j = 0; j < *dimension; ++j) {
      fprintf(stdout, "%f ", matrix[i*(*dimension)+j]);
    }
    fprintf(stdout, "\n");
  }
  
  return;
}





/* Device To Device Function Definitions */






