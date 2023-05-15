import numpy as np
import Accumulation
import ModelMethods


class GM:
    def __init__(self):
        self.mdl_name = 'gm11'
        self.is_fitted = False

    def fit(self, x, y):
        x1 = Accumulation.ago(y, None, True)
        z1 = ModelMethods.get_backvalue(x1)
        ones_array = np.diff(x).astype(np.float64)
        ones_array = ones_array.reshape([-1, 1])
        self.B = ModelMethods.construct_matrix(z1, ones_array)
        self.x_orig = y
        self.params = ModelMethods.get_params(self.B, y)
        self.is_fitted = True
        return self

    def predict(self, t):
        all_t = np.arange(0, np.max(t))
        x1_pred = GM_ResFunc().compute(self.params, all_t, self.x_orig[0])
        x_pred = Accumulation.ago(x1_pred, self.x_orig[0], False)
        return x_pred


class GM_ResFunc():
    def __init__(self):
        pass

    def compute(self, params, t, x_0):
        a = params[0]
        b = params[1]
        x1_pred = (x_0 - b / a) * np.exp(-a * t) + b / a
        return x1_pred
