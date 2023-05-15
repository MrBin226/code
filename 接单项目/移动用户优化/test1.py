import numpy as np

from scipy.integrate import quad

def f(x):
    return np.exp(x / 10)

print(quad(f, 0.5, 0.545))

