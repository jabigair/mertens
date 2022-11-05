import sys
import mpmath as mp
import numpy as np
import matplotlib.pyplot as plt
from lll_alg import lll,gram_schmidt,proj,gram_coeffs

if __name__=='__main__':
    if len(sys.argv) != 4:
        print("Usage: {} <zeros input file name> <arg input file name> <alpha input file>".format(sys.argv[0]))
        sys.exit(-1)

    mp.mp.dps = 100

    # read high prec imaginary parts
    zero_input_file = open(sys.argv[1],'r')
    zero_lines = zero_input_file.readlines()
    zero_input_file.close()
    high_prec_zero = [mp.mpf(num) for num in zero_lines]

    # read high prec arg
    arg_input_file = open(sys.argv[2],'r')
    arg_lines = arg_input_file.readlines()
    arg_input_file.close()
    high_prec_arg = [mp.mpf(num) for num in arg_lines]

    # read high prec alpha
    alpha_input_file = open(sys.argv[3],'r')
    alpha_lines = alpha_input_file.readlines()
    alpha_input_file.close()
    high_prec_alphas = [mp.mpf(num) for num in alpha_lines]

    # order values
    norm_high_prec_alphas = [mp.norm(alpha) for alpha in high_prec_alphas]
    norm_alphas = np.array(norm_high_prec_alphas)
    order = np.argsort(-1*norm_alphas)

    n = 70 
    v = 230 
    zero_array = np.array(high_prec_zero)
    arg_array = np.array(high_prec_arg)
    alpha_array = np.array(high_prec_alphas)
    gammas = zero_array[order][:n]
    args = arg_array[order][:n]
    alphas = alpha_array[order][:n]

    # set up array
    first_vector = [-mp.floor(mp.sqrt(alphas[i])*args[i]*2**v) for i in range(len(args))] + [mp.mpf((2**v)*(n**4)), mp.mpf(0.0)]
    second_vector = [mp.floor(mp.sqrt(alphas[i])*gammas[i]*(2**(v-10))) for i in range(len(args))] + [mp.mpf(0.0),mp.mpf(1.0)]
    lattice = [[mp.mpf(0.0)]*i + [mp.floor(2*mp.pi*mp.sqrt(alphas[i])*(2**v))] + [mp.mpf(0.0)]*(n-1-i) + [mp.mpf(0.0),mp.mpf(0.0)] for i in range(len(args))]
    lattice.insert(0,second_vector)
    lattice.insert(0,first_vector)
    lattice = Matrix([[int(num) for num in ls] for ls in lattice])

    # check shape of lattice is (n + 2) x (n + 2)
    if lattice.nrows() != (n + 2): raise Exception ("Lattice has incorrect size.")

    # run lll algorithm
    lll_red_lattice = lattice.LLL(delta = 0.99)

    # check there is only one vector with a nonzero (n + 1) term
    count = 0
    for i in range(n + 2):
        if mp.almosteq(lll_red_lattice[i][-2],mp.mpf(0.0),10**(-20)) == False:
            index = i
            count += 1
    if count > 1: raise Exception ("Lattice has too many long vectors.")
    elif count < 1: raise Exception ("Lattice has too few long vectors.")
    else:
        long_vector = lll_red_lattice[index]

    # longest vector, last value (= z), get y 
    if len(long_vector) != (n + 2): raise Exception ("Long vector is too short.")
    y = mp.mpf(long_vector[-1]) / 1024

    # evaluate h_k(y) for this y value
    def H(y,T,zeros,args,alphas):
        return 2 * sum([((1 - zeros[i]/T) * mp.cos(mp.pi*zeros[i]/T) + (mp.pi)**(-1) * mp.sin(mp.pi*zeros[i]/T)) * (alphas[i]*mp.cos(zeros[i]*y - args[i])) for i in range(0,2000)])  

    T = high_prec_zero[-1] # height of 2000th zero
    hk = H(y,T,high_prec_zero,high_prec_arg,high_prec_alphas)
    print(y)
    print(hk)

    fig,axes = plt.subplots()
    shift = 3
    step = 0.01 
    offsetsleft = np.arange(-shift, -step, step)
    offsetsright = np.arange(step, shift, step)
    xs = np.hstack([offsetsleft, 0, offsetsright])
    ys = [H(x+y,T,high_prec_zero,high_prec_arg,high_prec_alphas) for x in xs]
    axes.plot(xs,ys,color='black',linewidth=0.75)
    axes.set_ylabel(r'$h_K(y_0 + t)$')
    plt.savefig('mertens_graph.png',dpi=200)
    plt.show()

