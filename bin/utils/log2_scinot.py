import math
import sys

if __name__ == "__main__":
    # takes a number in the format 1.6e-300 or 4e3 and takes log2
    num=sys.argv[1]
    num_vec=num.split("e")
    print(math.log(float(num_vec[0]), 2) + (float(num_vec[1])*math.log(10, 2)))

