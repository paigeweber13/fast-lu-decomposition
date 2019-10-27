import argparse
import random

from typing import List

Matrix = List[List[float]]
Args = argparse.Namespace

HPP_BOILERPLATE = "#pragma once\n" \
    + "\n" \
    + "#include <boost/align/aligned_allocator.hpp>\n" \
    + "#include <vector>\n" \
    + "\n" \
    + "using namespace std;\n" \
    + "\n"


VECTOR_OF_MATRICES_START = "\n" \
    + "const vector<vector<vector<\n" \
    + "             float, boost::alignment::aligned_allocator<float, 32>\n" \
    + ">>> test_matrices({\n"


VECTOR_OF_MATRICES_END = "});\n"


def create_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description='Generate square ' +\
        'matrices to test speed of LU decomposition')
    parser.add_argument('upper_limit', 
                        help='Maximum dimension of generated matrices')
    parser.add_argument('-l', '--lower_limit', default=None, nargs='?',
                        help='Minimum dimension of generated matrices')
    parser.add_argument('-s', '--step', dest='step', default=None, nargs='?',
                        help='Step in dimension of generated matrices whose ' \
                            'sizes increase linearly')
    parser.add_argument('-r', '--ratio', dest='ratio', default=None, nargs='?',
                        help='Ratio of increase of dimension in generated '\
                            'matrices whose sizes increase exponentially')
    parser.add_argument('-o', '--output_file', dest='output_file',
                        default='test_matrices.hpp', nargs='?',
                        help='File to save output to')
    return parser


def prepare_args(args: Args) -> Args:
    ## convert to integers, but convert to float first to allow use of
    ## scientific notation like '1e6'
    args.upper_limit = int(float(args.upper_limit))
    if args.step is None:
        args.step = args.upper_limit/10
    if args.lower_limit is None:
        args.lower_limit = args.step
    args.lower_limit = int(float(args.lower_limit))
    args.step = int(float(args.step))


def generate_matrix(n: int) -> Matrix:
    result = []
    for i in range(n):
        result.append([])
        for _ in range(n):
            result[i].append(random.random())
    return result


def matrix_as_cpp_literal(matrix: Matrix) -> str:
    result =  '{\n'
    for i in range(len(matrix)):
        result += '{'
        for j in range(len(matrix)):
            result += str(matrix[i][j]) + ','
        result += '},\n'
    result += '},\n'
    return result


def main():
    # Process args
    args = process_args(create_argparser().parse_args())

    # Build header file with text in it
    output_text = HPP_BOILERPLATE \
                + VECTOR_OF_MATRICES_START \

    for n in range(args.lower_limit, args.upper_limit, args.step):
        output_text += matrix_as_cpp_literal(generate_matrix(n))

    output_text += VECTOR_OF_MATRICES_END

    # Output that text
    with open(args.output_file, 'w') as f:
        f.write(output_text)


if(__name__ == '__main__'):
    main()
