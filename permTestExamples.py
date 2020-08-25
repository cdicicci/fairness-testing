"""
This script is used to generate the simulation results for the FairTest permutation
test implementation from section 4.1 of the paper Evaluating Fairness Using Permutation Tests
"""

import numpy as np
import math
import random
import scipy.stats as stats
from matplotlib import pyplot as plt
from IPython.display import clear_output



def permutation_test_corr(x, y, num_samples=10000):
    """
    This function is the permutation test implemented by FairTest
    
    Monte-Carlo permutation test for correlation
    Parameters
    ----------
    x :
        Values for the first dimension
    y :
        Values for the second dimension
    num_samples :
        the number of random permutations to perform
    Returns
    -------
    pval :
        the p-value
    References
    ----------
    https://en.wikipedia.org/wiki/Resampling_(statistics)
    """
    x = np.array(x, dtype='float')
    y = np.array(y, dtype='float')

    obs_0, _ = stats.pearsonr(x, y)
    k = 0
    z = np.concatenate([x, y])
    for _ in range(num_samples):
        np.random.shuffle(z)
        k += abs(obs_0) < abs(stats.pearsonr(z[:len(x)], z[len(x):])[0])
    pval = (1.0*k) / num_samples
    return max(pval, 1.0/num_samples)

pval = 0;
N = 10000;
samp_size = 2000;

for i in range(N):
    sampl = np.random.uniform(low=1e-5, high=1, size=(samp_size,))
    errors = np.random.normal(0, 1, samp_size)
    errors = np.divide(errors, np.sqrt(np.square(sampl)))
    pval += (permutation_test_corr(sampl,errors, 1000)<.05)

print("Rejection probability for uncorrelatedness example:")
print(pval/N)

pval = 0;
for i in range(N):
    sampl = np.random.exponential(1, samp_size) + 1
    errors = np.random.normal(0, 1, samp_size)
    errors = np.divide(errors, np.sqrt(np.square(sampl)))
    pval += (permutation_test_corr(sampl,errors, 1000)<.05)
    
print("Rejection probability for independence example:")
print(pval/N)