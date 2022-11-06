# Disproof of the Mertens conjecture

## The conjecture

To state the Mertens conjecture, we first need two definitions. Let

$$
    \mu(n) = 
    \begin{cases}
        1 \qquad &\text{if $n = 1$,} \\
        (-1)^k \qquad &\text{if $n$ is a product of $k$ distinct primes,} \\
        0 \qquad &\text{if } p^2 \mid n, \text{ for some prime $p$,} \\
    \end{cases}
$$

be the M&#0246;bius function and let $M(x) = \sum_{n \leq x} \mu(n)$. The Mertens conjecture states that, for $x > 1$,

$$
    |M(x)| < \sqrt{x}.
$$

Equivalently, for $x > 1$, $|M(x)|/\sqrt{x}$ is bounded by 1. This conjecture was disproved in 1985 by Odlyzko and te Riele. They showed that

 $$
        \begin{align*}
            \limsup_{x\to\infty} M(x) / \sqrt{x} &> 1.06 \\
            \liminf_{x\to\infty} M(x) / \sqrt{x} &< -1.009.
        \end{align*}
 $$

This result shows that there is some $x$ for which $M(x) / \sqrt{x}$ is larger than $1.06$, and another $x$ for which $M(x) / \sqrt{x}$ is smaller than $-1.009$. 

## The disproof, in brief

There is a lot of analytic number theory that goes into the disproof of the Mertens conjecture, so we'll just highlight what is most important to understand when working with the code. For more detailed information, see the original disproof in Odlzko and te Riele's paper.

In 1942, Ingham was able to reduce the study of the size of $M(x) \sqrt{x}$ to the study of the size of a much simpler, finite sum. This sum is given by 

$$
    h_ {k}(y) = 2 \sum_ {0 < \gamma} k(\gamma) \frac{\cos(y\gamma - \psi_ {\gamma}}{|\rho \zeta'(\rho)|},
$$

where $\rho$ is a nontrivial zero of the zeta function, $\gamma$ is the imaginary part of $\rho$, $\psi_ {\gamma}$ is the argument of $\rho \zeta'(\rho)$, and $k$ is function that looks roughly like $(1 + \text{something small})$ on a finite interval (and is zero everywhere else). 

Ingham showed that, if we can find a $y_ {0}$ such that $h_ {k}(y_ {0})$ is large, then there is some $x$ such that $M(x) / \sqrt{x}$ is large. So, to disprove the Mertens conjecture, it is enough to find such a $y_ {0}$. This is what Odlyzko and te Riele did, and we'll outline part of their process below.

Recall that $k$ is only nonzero on a finite interval, so there is some $T$ such that $k(\gamma) \neq 0$ when $0 < \gamma < T$. This means that

$$
    \begin{align*}
        h_ {k}(y) &= 2 \sum_ {0 < \gamma < T} (1 + \text{small}) \frac{\cos(y\gamma - \psi_ {\gamma})}{|\rho \zeta'(\rho)|} \\
        &\approx 2 \sum_ {0 < \gamma < T} \frac{\cos(y\gamma - \psi_ {\gamma})}{|\rho \zeta'(\rho)|}.
    \end{align*}
$$

We can write the above as 

$$
    \begin{align*}
        h_ {k}(y) &\approx 2 \sum_ {i=1}^{N} \frac{\cos(y\gamma_i - \psi_ {i})}{|\rho_ {i} \zeta'(\rho_ {i})|},
    \end{align*}
$$

where $\rho_ {N}$ is the last zero of zeta with imaginary part strictly less than $T$. Now let $\alpha_ {i} = \frac{1}{|\rho_ {i} \zeta'(\rho_ {i})|}$. Then we have that

$$
    \begin{align*}
    h_ {k}(y) &\approx 2 \sum_ {i=1}^{N} \frac{\cos(y\gamma_ {i} - \psi_ {i})}{|\rho_ {i} \zeta'(\rho_ {i})|} \\
        &= 2 \sum_ {i=1}^{N} \alpha_ {i} \cos(y\gamma_ {i} - \psi_{i}) \\
        &= 2 \sum_ {i=1}^{N} \alpha_ {i} \cos(y\gamma_ {i} - \psi_{i} - 2\pi m_ {i}),
    \end{align*}
$$

for some $m_ {i} \in \mathbb{Z}$.

Using the Taylor series for cosine, we have that

$$
    \begin{align*}
        h_ {k}(y) &\approx 2 \sum_ {i=1}^{N} \alpha_ {i} - \sum_ {i=1}^{N} \alpha_ {i} (y\gamma_ {i} - \psi_ {i} - 2\pi m_ {i})^2 \\
        &= 2 \sum_ {i=1}^{N} \alpha_ {i} - \sum_ {i=1}^{N} (\sqrt{\alpha_ {i}} (y\gamma_ {i} - \psi_ {i} - 2\pi m_ {i}))^2.
    \end{align*}
$$

If we take $N$ sufficiently large, then we know that this first sum will be big. (A previous result of Titchmarsh showed that the sum over all of the $\alpha_ {i}$ diverges.) So if we choose a $y$ for which the second sum is small, we'll be able to make $h_ {k}(y)$ large, as desired. Notice that making this second sum small is equivalent to choosing a $y$ such that $(y \gamma_ {i} - \psi_ {i})$ is close to some multiple of $2\pi$. [^1] To choose $y$, Odlyzko and te Riele constructed a particular lattice and used the LLL algorithm to get a guess for what this $y$ should look like. 

The $y_ {0}$ they got from this process yielded a value for $h_ {k}$ that was greater than one. This proved that there was some $x$ such that $M(x) / \sqrt{x} > 1$. A similar computation can be used to break the conjectured lower bound as well, thereby disproving the Mertens conjecture.

[^1]: Note that this discussion (and this code) proves the $\limsup$ case. To get the $\liminf$ result, we'd instead minimize $(y\gamma_i - \psi_i - \pi - 2\pi m_i)$. This is equivalent to making the cosine in the numerator of $h_k(y)$ close to $-1$.

## How to run the code
 
This program only replicates the disproof for the $\limsup$ case, though the proof for the $\liminf$ case is similar. 

To start off, we need zeros of the zeta function. Odlyzko has [published](http://www.dtc.umn.edu/~odlyzko/zeta_tables/index.html) such values to various precisions, which we'll use (see `low_prec_zeros.txt`). We will need just the first 2000 zeros in this file.

The precision of these zeros is not high enough for the argument given by Odlyzko and te Riele, so we use the [mpmath](https://mpmath.org/) library to increase the precision. In particular, to get high enough precision for the zeros and for the derivative of the zeta function evaluated at these zeros, we run the program `zeta_zeros.py` with `low_prec_zeros.txt` as an input. We also give this program the names we want the high-precision zeros file and high-precision derivatives file to have. (This process may take a few minutes.)

From here, we need to calculate $\alpha$ and $\psi$, as defined above, to a high precision. To do this, we run `zeta_arg_alpha.py` with the filenames for the high precision zeros and derivatives, plus the names for the output files, which will contain the high precision $\psi$'s and high-precision $\alpha$'s, respectively. (In the programs, the $\psi$ values are referred to as `arg`, short for argument.)

Now we have all the highly precise pieces we need to run Odlyzko and te Riele's argument. All we need to do is run `mertens.sage` with the input files for the high-precision zeros, high-precision $\psi$'s, and high-precision $\alpha$'s. 

Then, the `mertens.sage` program will print $y_ {0}$ and $h_ {k}(y_ {0})$. It will also produce a plot of $h_ {k}$ around $y_ {0}$, which it will show and save to the file `mertens_graph.png`. 

For simplicity, we've included our high-precision files in the folder `high_ prec`, which can be used instead of constructing your own.

