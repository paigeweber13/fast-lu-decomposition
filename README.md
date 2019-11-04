# fast-lu-decomposition
Exercise to optimize the decomposition of a matrix, which finds applications in
machine learning and scientific computing. Created as a term project for ITCS
4182 at UNCC.

## Buiding
### Prerequisites
 * This project uses [conan](https://docs.conan.io/en/latest/installation.html)
   for package management. make sure you have it installed.
     * the easiest way to install it is with pip. Run `pip install conan`
 * GNU Make is used for building

### Instructions
Clone this repository and run the following commands where it's cloned:

    mkdir build
    cd build
    conan install ..
    cd ..
    make

You may then run using `./lu-decomp`. Alternatively, you may also run `make
test` to compile and run in one command.

## Guidance from professor:
 * Problem: Solve Ax = b.
 * Build two triangular matrices L and U such that A = LU.
 * Allows to solve Ax = b in O(n) time.
 * Algorithm is known (essentially what you saw in Linear Algebra) (Essentially
   Gauss’ inversion)
