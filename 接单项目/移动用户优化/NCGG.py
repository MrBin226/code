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


def cal_g_un(u):
    g_un = g_0 / (np.sum((coordinate_u[u, :] - coordinate_n) ** 2, axis=1) + H ** 2)
    return g_un


def cal_gama(u, p):
    g_un = cal_g_un(u)
    temp = 0
    for i in range(U):
        if i == u:
            continue
        else:
            temp += p[i, :] * cal_g_un(i)
    gama = g_un / (delta + temp)
    return gama


def cal_e_arg(u, pp):
    p = pp.copy()
    E = np.zeros(p.shape)
    ppp = pp[u, :]
    for i in range(U):
        if i == u:
            p[u, :] = ppp
        else:
            p[u, :] = p[i, :]
        gama = cal_gama(u, p)
        E[i, :] = p[u, :] * I / (B * np.log2(1 + gama * p[u, :]))
    return E

def cal_all_e(p):
    E = np.zeros(N)
    for i in range(U):
        gama = cal_gama(i, p)
        E += p[i, :] * I / (B * np.log2(1 + gama * p[i, :]))
    return E

def ncgg():
    p = np.ones(shape=(U, N)) * max_w
    r = 0
    all_E = 0
    while True:
        r += 1
        u_r = 0.1 / np.sqrt(r)
        pre_E = all_E
        for u in range(U):
            gama = cal_gama(u, p)
            delta_u = u_r * I * (np.log2(1 + gama * p[u, :]) * np.log(2) * (1 + gama * p[u, :])
                                 - gama * p[u, :]) / (B * np.log(2) * (1 + gama * p[u, :]) *
                                                      (np.log2(1 + gama * p[u, :]) ** 2))
            p[u, :] = p[u, :] - delta_u
            p[u, p[u, :] < 0] = 0
            E = cal_e_arg(u, p)
            index = np.argmin(E, axis=0)
            p_u = np.zeros(N)
            for i, idx in enumerate(index):
                p_u[i] = p[idx, i]
            p[u, :] = p_u
        all_E = np.sum(cal_all_e(p))
        print(f"第{r}次迭代")
        if abs(all_E - pre_E) < fazhi:
            print("各个用户的发射功率如下：")
            print(p)
            for i in range(U):
                print(f"第{i+1}个用户在各个BS的功率为：", p[i,:])
            break


if __name__ == '__main__':
    ncgg()


