# Disproof of the Mertens conjecture

## How to use

The `low_prec_zeros.txt` file is from `http://www.dtc.umn.edu/~odlyzko/zeta_tables/index.html`, which is where Odlyzko has published values for the zeros of the zeta function to various precisions. We will need just the first 2000 zeros in this file.

The precision of these zeros is not high enough for the argument given by Odlyzko and te Riele, so we use the `mpmath` library to increase the precision. In particular, to get high enough precision for the zeros and for the derivative of the zeta function evaluated at these zeros, we run the file `zeta_zeros.py` with `low_prec_zeros.txt` as an input. We also give this program the names we want the high-precision zeros file and high-precision derivatives file to have. (This process may take a few minutes.)

From here, we need to calculate $\alpha$ and $\psi$, as defined above, to a high precision. To do this, we run `zeta_arg_alpha.py` with the filenames for the high precision zeros and derivatives, plus the names for the output files, which will contain the high precision $\psi$'s and high-precision $\alpha$'s, respectively. (In the programs, the $\psi$ values are referred to as `arg`, short for argument.)

Now we have all the highly precise pieces we need to run Odlyzko and te Riele's argument. All we need to do is run `mertens.sage` with the input files for the high-precision zeros, high-precision $\psi$'s, and high-precision $\alpha$'s. 

Then, the `mertens.sage` program will print $y_ {0}$ and $h_ {k}(y_ {0})$. It will also produce a plot of $h_ {k}$ around $y_ {0}$, which it will show and save to the file `mertens_graph.png`. 

For simplicity, we've included our high-precision files in the folder `high_ prec`, which can be used instead of constructing your own.
