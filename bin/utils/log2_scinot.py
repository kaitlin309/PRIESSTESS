import math
import sys

if __name__ == "__main__":
    # takes a number in the format 1.6e-300 or 4e3 and takes log2
    # now also works if the number is not in scientific notation
    num=sys.argv[1]
    # For some users, numbers are in the format "1,6e-300" instead of "1.6e-300"
    if "," in num:
        num = num.replace(",", ".")
    if "e" in num:
        num_vec=num.split("e")
        print(math.log(float(num_vec[0]), 2) + (float(num_vec[1])*math.log(10, 2)))
    else:
        print(math.log(float(num), 2))

