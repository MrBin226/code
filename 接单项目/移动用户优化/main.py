import numpy as np

# 参数设置
U = 12  # 用户人数
N = 3  # BS数量
max_w = 4  # 用户的最大传输功率
delta = 9.9e-14  # δ_0平方
fazhi = 0.005
H = 10
coordinate_u = np.random.randint(50, 200, size=(U, 2))  # 用户坐标
coordinate_n = np.random.randint(100, 150, size=(N, 2))  # BS坐标
g_0 = 20
I = 600  # 用户传输的数据量
B = 0.2*10**6



