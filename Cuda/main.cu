/* Standard C++ Header Files */
#include <chrono>
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <ctime>

__global__ void findTransform(int *, int *, double *, double *);
__global__ void elimination(int *, int *, double *, double *);
__host__ void generateMatrixData(double *, int *);
__host__ void printMatrix(double *, int *);


/* Start Of Program Execution */
int main(int argc, char **argv)
{
  if(argc < 2) { // Cause why not
    fprintf(stderr, "\nERROR: usage: %s <n>\n\t<n>: matrix dimension\n", argv[0]);
    exit(1);
  }

  srand(time(0)); // Seed randomizer

  FILE *cudaerr = fopen("cuda_error.txt", "w");
  if(cudaerr == NULL) {
    fprintf(cudaerr, "ERROR: Cuda Error File Could Not Be Opened!");
    exit(2);
  }

  // Parse Command Line (edit once case 10 works)
  int dimension = 10; //atoi(argv[1]);

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
  int *d_dimension;
  int *d_n;
  int *d_pivot;
  double *d_matrix;
  double *d_upperMatrix;
  double *d_lowerMatrix;
  cudaMalloc((void **)&d_dimension, sizeof(int));
  fprintf(cudaerr, "Allocate d_dimension: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMalloc((void **)&d_n, sizeof(int));
  fprintf(cudaerr, "Allocate d_n: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMalloc((void **)&d_pivot, sizeof(int));
  fprintf(cudaerr, "Allocate d_pivot: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMalloc((void **)&d_matrix, sizeof(double) * n);
  fprintf(cudaerr, "Allocate d_matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMalloc((void **)&d_upperMatrix, sizeof(double) * n);
  fprintf(cudaerr, "Allocate d_upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMalloc((void **)&d_lowerMatrix, sizeof(double) * n);
  fprintf(cudaerr, "Allocate d_lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));

  // Start Timer
  std::chrono::time_point<std::chrono::steady_clock> start = std::chrono::steady_clock::now();

  // Copy Host Data To Device Memory
  cudaMemcpy(d_dimension, &dimension, sizeof(int), cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy lowerMatrix to dimension: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(d_matrix, matrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy matrix to d_matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(d_upperMatrix, upperMatrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy upperMatrix to d_upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(d_lowerMatrix, lowerMatrix, sizeof(double) * n, cudaMemcpyHostToDevice);
  fprintf(cudaerr, "Copy lowerMatrix to d_lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));


  /* Actaul Main Algorithm */

  for(int i = 0; i < dimension; ++i) { // Loop through pivots
    int pivot = i * dimension + i;
    cudaMemcpy(d_pivot, &pivot, sizeof(int), cudaMemcpyHostToDevice);
    fprintf(cudaerr, "Copy matrix to d_pivot iteration %d: %s\n", i, cudaGetErrorString(cudaGetLastError())); // Remove for benchmarking

    findTransform<<<1,1>>>(d_pivot, d_dimension, d_matrix, d_lowerMatrix); // Column To 0 And Find Lower (can this be done in parallel)?

    cudaDeviceSynchronize(); // Do wee need this?
    fprintf(cudaerr, "Synchronize after findTransform iteration %d: %s\n", i, cudaGetErrorString(cudaGetLastError())); // Remove for benchmarking

    elimination<<<1,1>>>(d_pivot, d_dimension, d_matrix, d_lowerMatrix); // To be done in parallel
        
    cudaDeviceSynchronize(); // Also do we need this?
    fprintf(cudaerr, "Synchronize after elimination iteration %d: %s\n", i, cudaGetErrorString(cudaGetLastError())); // Remove for benchmarking
  }

  // Copy Device Data to Host Memory
  cudaMemcpy(matrix, d_matrix, sizeof(double) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_matrix to matrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(upperMatrix, d_upperMatrix, sizeof(double) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_upperMatrix to upperMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaMemcpy(lowerMatrix, d_lowerMatrix, sizeof(double) * n, cudaMemcpyDeviceToHost);
  fprintf(cudaerr, "Copy d_lowerMatrix to lowerMatrix: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaDeviceSynchronize();
  fprintf(cudaerr, "Synchronize after copying to device: %s\n", cudaGetErrorString(cudaGetLastError()));

  // End Timer
  std::chrono::time_point<std::chrono::steady_clock> end = std::chrono::steady_clock::now();
  std::chrono::duration<double> time = end - start;

  // Printing for testing
  printMatrix(matrix, &dimension);
  printMatrix(upperMatrix, &dimension);
  printMatrix(lowerMatrix, &dimension);

  // Deallocate Device Data
  cudaFree(d_dimension);
  fprintf(cudaerr, "Free d_dimension: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaFree(d_n);
  fprintf(cudaerr, "Free d_n: %s\n", cudaGetErrorString(cudaGetLastError()));
  cudaFree(d_pivot);
  fprintf(cudaerr, "Free d_pivot: %s\n", cudaGetErrorString(cudaGetLastError()));
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


__global__ void findTransform(int *pivot, int *dimension, double *matrix, double *lowerMatrix)
{ 
  double factor = matrix[(*pivot) * (*dimension) + (*pivot)];
  for(int i = (*pivot), j = (*pivot); i < (*dimension)*(*dimension); i +=(*dimension), ++j) {
    lowerMatrix[(*pivot)+j*(*dimension)] = matrix[j+(*pivot)*(*dimension)] / factor;
  }
}


__global__ void elimination(int *pivot, int *dimension, double *matrix, double *lowerMatrix)
{
  //int index = threadIdx.x + blockIdx.x * blockDim.x;
  for(int j = (*pivot); j < (*dimension); ++j) {
    for(int i = (*pivot); i < (*dimension); ++i) {
      matrix[(i+(*pivot + 1)*(*dimension))+j*(*dimension)] = (-1) * lowerMatrix[j*(*dimension)] * matrix[j+(*pivot)*(*dimension)] + matrix[i+j*(*dimension)];
    }
  }
  return;
}


__host__ void generateMatrixData(double *matrix, int *n)
{
  for(int i = 0; i < *n; ++i) {
    matrix[i] = rand() % 99 + 1;
  }
 
  return;
}


__host__ void printMatrix(double *matrix, int *dimension)
{
  fprintf(stdout, "\nMatrix:\n");
  for(int i = 0; i < *dimension; ++i) {
    for(int j = 0; j < *dimension; ++j) {
      fprintf(stdout, "%8.4f ", matrix[i*(*dimension)+j]);
    }
    fprintf(stdout, "\n");
  }
  
  return;
}
