import argparse


def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument("--r-script", default=None, dest="rScript", help="R script to be executed.")
    parser.add_argument("--input-data-file", default=None, dest="inputDataFile", help="Input data file name with full path.")
    parser.add_argument("--output-data-file", default=None, dest="outputDataFile", help="Output data file name with full path.")

    return parser.parse_args()
