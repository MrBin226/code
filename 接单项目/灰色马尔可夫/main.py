import numpy as np
import matplotlib.pyplot as plt
from GM11 import GM
import pandas as pd

plt.rcParams['font.family'] = 'SimHei'


# 级比检验
def deal_data(data, c):
    times = 0
    while True:
        i = 1
        while i < len(data):
            proportion = data[i - 1] / data[i]
            if np.exp(-2 / (len(data) + 1)) < proportion < np.exp(2 / (len(data) + 1)):
                i = i + 1
            else:
                data = data + [c] * len(data)
                times += 1
                break
        if i == len(data):
            break
    print("通过级比检验，平移次数：", times)
    return data, times


def states_learn(y0):
    a, b = np.min(y0), np.max(y0)
    delta = (b - a) / 3
    states = []
    for i in range(3):
        states.append([a + i * delta, a + (i + 1) * delta])

    s = np.zeros(len(y0))
    for i, xi in enumerate(y0):
        for j, state in enumerate(states):
            if state[0] <= xi < state[1] or (j == len(states) - 1 and xi == state[1]):
                s[i] = j
                break
    return s, states


# 计算n步概率转移矩阵
def matrixPow(Matrix, n):
    if type(Matrix) == list:
        Matrix = np.array(Matrix)
    if n == 1:
        return Matrix
    else:
        return np.matmul(Matrix, matrixPow(Matrix, n - 1))


def transfer_mat(y0, y1, step, s, state):
    y_cor = y1.copy()
    p = np.zeros((3, 3))
    for i in range(3):
        for j in range(3):
            t1 = (s[:-1] == i)
            t2 = (s[1:] == j)
            t = [a and b for a, b in zip(t1, t2)]
            p[i, j] = (np.sum(t) / np.sum((s[:-1] == i))) if np.sum((s[:-1] == i)) > 0 else 0
    print("状态：", state)
    print("状态转移概率矩阵：")
    print(p)
    for i in range(1, len(y0)):
        y_cor[i] += np.sum(state[int(s[i])]) / 2
    last_state = int(s[-1])
    for i in range(len(y0), step + len(y0)):
        p_i = matrixPow(p, i - len(y0) + 1)
        ss = int(np.argmax(p_i[last_state]))
        y_cor[i] += np.sum(state[ss]) / 2
    return y_cor


def check_result(data, data_h):
    # 计算平均相对误差
    error = np.mean(np.abs((data - data_h) / data))
    print("平均相对误差：", error * 100, "%")

    e = np.abs((data - data_h) / data)  # 相对误差
    s1 = np.sum(e ** 2)  # 原始序列的后验方差
    s2 = np.sum(np.diff(data) ** 2) / (len(data) - 1)  # 残差序列的方差
    # 后验差比
    C = s1 / s2
    # 结果
    print("后验差比C：", C)
    if C <= 0.35:
        print('检验精度1级，效果好')
    elif 0.5 >= C >= 0.35:
        print('检验精度2级，效果合格')
    elif 0.65 >= C >= 0.5:
        print('检验精度3级，效果勉强')
    else:
        print('检验精度4级，效果不合格')


if __name__ == '__main__':
    x0 = np.array([2124.55, 2018.44, 1948.27, 1862.91, 1793.82])[::-1]
    label = "总量"
    t = np.arange(1, len(x0) + 1)
    c = 0.1
    x0, d = deal_data(x0, c)
    gm = GM()
    gm.fit(t, x0)
    predict_year_num = 5  # 预测步数
    x1 = gm.predict(predict_year_num + len(x0))
    x = x0 - x1[:len(x0)]
    s, state = states_learn(x)
    x2 = transfer_mat(x, x1, predict_year_num, s, state)
    check_result(x0, x2[: len(x0)])

    x0 -= c * d
    x1 -= c * d
    x2 -= c * d

    df = pd.DataFrame(np.zeros((5, 5)), columns=["真实值", "灰色预测值", "灰色预测相对误差", "灰色马尔可夫预测值",
                                                 "灰色马尔可夫预测相对误差"],
                      index=[str(i) + "年" for i in range(2017, 2022)])
    df["真实值"] = x0
    df["灰色预测值"] = x1[:len(x0)]
    df["灰色预测相对误差"] = np.abs(x / x0)
    df["灰色马尔可夫预测值"] = x2[:len(x0)]
    df["灰色马尔可夫预测相对误差"] = np.abs((x0 - x2[:len(x0)]) / x0)
    df.to_excel("result.xlsx")

    for i in range(predict_year_num):
        print(i + 2022, "年预测值：", x2[i + len(x0)])

    plt.plot(range(2017, len(x0) + 2017), x0, 'r-o', label="y_true")
    plt.plot(range(2017, len(x2) + 2017), x2, 'c-o', label="y_predict")
    plt.xlabel("年份")
    plt.ylabel(label)
    plt.legend(labels=["真实值", "预测值"], loc="best")
    plt.show()
