import sys
import mpmath as mp

if __name__=='__main__':
    # import low prec zeros
    if len(sys.argv) != 4:
        print("Usage: {} <input low precision zeros file name> <zeros output file name> <derivatives output file name>".format(sys.argv[0]))
        sys.exit(-1)

    input_file = open(sys.argv[1],'r')
    lines = input_file.readlines()
    input_file.close()
    low_prec_imag_part = [float(num) for num in lines[0:2000]]

    # get high prec version of first 2000 zeros
    mp.mp.dps = 100
    high_prec_zeros = [mp.findroot(mp.zeta, 0.5 + imag_part*mp.j) for imag_part in low_prec_imag_part]

    # evaluate derivative for each zero
    zeta_derivatives = [mp.zeta(zero, derivative=1) for zero in high_prec_zeros]

    # write to files
    zeros_output_file = open(sys.argv[2], 'w')
    deriv_output_file = open(sys.argv[3], 'w')
    for i in range(len(high_prec_zeros)):
        zeros_output_file.write(mp.nstr(high_prec_zeros[i].imag,100) + '\n')
        deriv_output_file.write(mp.nstr(zeta_derivatives[i],100) + '\n')
    zeros_output_file.close()
    deriv_output_file.close()
