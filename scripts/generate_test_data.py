import argparse
import random

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
    parser.add_argument('lower_limit', 
                        help='Minimum dimension of generated matrices')
    parser.add_argument('upper_limit', 
                        help='Maximum dimension of generated matrices')
    parser.add_argument('-s', '--step', dest='step', default=None, nargs='?',
                        help='Step in dimension of generated matrices')
    parser.add_argument('-o', '--output_file', dest='output_file',
                        default='test_matrices.hpp', nargs='?',
                        help='File to save output to')
    return parser


def generate_matrix(n: int) -> [[]]:
    result = []
    for i in range(n):
        result.append([])
        for _ in range(n):
            result[i].append(random.random())
    return result


def matrix_as_cpp_literal(matrix: [[]]) -> str:
    result =  '{\n'
    for i in range(len(matrix)):
        result += '{'
        for j in range(len(matrix)):
            result += str(matrix[i][j]) + ','
        result += '},\n'
    result += '},\n'
    return result


def main():
    args = create_argparser().parse_args()

    # convert to integers, but convert to float first to allow use of
    # scientific notation like '1e6'
    args.upper_limit = int(float(args.upper_limit))
    args.lower_limit = int(float(args.lower_limit))
    if(args.step == None):
        args.step = args.upper_limit/10
    args.step = int(float(args.step))

    output_text = HPP_BOILERPLATE \
                + VECTOR_OF_MATRICES_START \

    for n in range(args.lower_limit, args.upper_limit, args.step):
        output_text += matrix_as_cpp_literal(generate_matrix(n))

    output_text += VECTOR_OF_MATRICES_END

    print(output_text)


if(__name__ == '__main__'):
    main()
