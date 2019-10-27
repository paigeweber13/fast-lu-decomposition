import argparse

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
                        default='test_data.hpp', nargs='?',
                        help='File to save output to')
    return parser


def main():
    parser = create_argparser()
    args = parser.parse_args()

    if(args.step == None):
        args.step = float(args.upper_limit)/10

    print(args)


if(__name__ == '__main__'):
    main()
