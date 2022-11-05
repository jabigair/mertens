import sys
import mpmath as mp

if __name__=='__main__':
    if len(sys.argv) != 5:
        print("Usage: {} <zeros input file name> <derivatives input file name> <arg output file name> <alpha output file>".format(sys.argv[0]))
        sys.exit(-1)

    mp.mp.dps = 100

    # read high prec zeros
    zeros_input_file = open(sys.argv[1],'r')
    zero_lines = zeros_input_file.readlines()
    zeros_input_file.close()
    high_prec_imag_part = [mp.mpf(num) for num in zero_lines]

    # read high prec derivatives
    deriv_input_file = open(sys.argv[2],'r')
    deriv_lines = deriv_input_file.readlines()
    deriv_input_file.close()
    high_prec_derivs = [mp.mpmathify(num) for num in deriv_lines]

    # evaluate rho * zeta'(rho)
    rho_times_zeta = [(0.5 + high_prec_imag_part[i]*mp.j)*high_prec_derivs[i] for i in range(len(high_prec_imag_part))]

    # evaluate arg of (rho * zeta'(rho))
    arg_rhos = [mp.arg(rho) for rho in rho_times_zeta]

    # evaluate reciprocal of (rho * zeta'(rho))
    alpha_rhos = [1/abs(rho) for rho in rho_times_zeta]

    # write to files
    arg_output_file = open(sys.argv[3], 'w')
    alpha_output_file = open(sys.argv[4], 'w')
    for i in range(len(rho_times_zeta)):
        arg_output_file.write(mp.nstr(arg_rhos[i],100) + '\n')
        alpha_output_file.write(mp.nstr(alpha_rhos[i],100) + '\n')
    arg_output_file.close()
    alpha_output_file.close()
