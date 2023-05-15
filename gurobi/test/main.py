from gurobipy import *
import pandas as pd
from geopy.distance import geodesic
import matplotlib.pyplot as plt


def get_data():
    df1 = pd.read_excel(r"配送中心数据.xlsx")
    df2 = pd.read_excel(r"需求点数据.xlsx")
    depot = [i - df1.shape[0] for i in range(df1.shape[0])]
    C = [i for i in range(1, df2.shape[0] + 1)]
    N = depot + C
    Q = {i: df2.iloc[i - 1, 3] for i in C}
    ET = {i: df2.iloc[i - 1, 4] for i in C}
    LT = {i: df2.iloc[i - 1, 5] for i in C}
    ST = {i: df2.iloc[i - 1, 6] for i in C}
    distance = {(i, j): geodesic(df2.iloc[i - 1, 1:3][::-1], df2.iloc[j - 1, 1:3][::-1]).km for i in C for j in C if
                i != j}
    for i in depot:
        ET[i] = 0
        LT[i] = 10 ** 3
        ST[i] = 0
        Q[i] = 0
        for j in C:
            distance[(i, j)] = geodesic(df1.iloc[i + df1.shape[0], :][::-1], df2.iloc[j - 1, 1:3][::-1]).km
    for j in depot:
        for i in C:
            distance[(i, j)] = geodesic(df1.iloc[j + df1.shape[0], :][::-1], df2.iloc[i - 1, 1:3][::-1]).km
    for i in depot:
        for j in depot:
            distance[(i, j)] = geodesic(df1.iloc[i + df1.shape[0], :][::-1], df1.iloc[j + df1.shape[0], :][::-1]).km
    TT = dict()
    for i, j in distance.keys():
        TT[(i, j)] = distance[(i, j)] * 60 / 30
    n_vehicles = len(C)
    return depot, C, N, Q, distance, n_vehicles, TT, ET, LT, ST, df1, df2.iloc[:, 1:3]


def buildModel(depot, C, N, Q, distance, n_vehicles, TT, ET, LT, ST, cap=8):
    """

    :param depot: 配送中心集合
    :param C: 需求点集合
    :param N: {depot}U{C}
    :param Q: 各个需求点的需求量
    :param distance: 两两点之间的距离
    :param n_vehicles: 最大车辆数
    :param TT: 两点之间的行驶时间
    :param ET: 最早服务时间
    :param LT: 最晚服务时间
    :param ST: 服务时间
    :param cap: 车辆容量
    :return:
    """
    depot = tuplelist(depot)
    C = tuplelist(C)
    N = tuplelist(N)
    Q = tupledict(Q)
    distance = tupledict(distance)
    TT = tupledict(TT)
    ET = tupledict(ET)
    LT = tupledict(LT)
    ST = tupledict(ST)
    K = tuplelist(range(n_vehicles))
    M = 10 ** 5
    "参数设置"
    P1 = 500
    r1 = 1
    r2 = 2
    P2 = 6
    P3 = 60000
    theta = 0.002
    P4 = 500
    f = 840 * (10 ** -5)
    sigma = 3.21
    P5 = 0.5

    # 模型创建
    model = Model()
    # 变量设置
    X = model.addVars(N, N, K, vtype=GRB.BINARY, name='X(i,j,k)')
    T = model.addVars(N, K, vtype=GRB.CONTINUOUS, lb=0, name='T(i,k)')
    D = model.addVars(N, K, vtype=GRB.CONTINUOUS, lb=0, name='D(i,k)')
    kpi = model.addVars(5, vtype=GRB.CONTINUOUS, name='kpi')
    # 目标函数
    z1 = quicksum(X[i, j, k] * P1 for i in C for j in depot for k in K)
    # z1 = quicksum(X[i, j, k] * distance[i, j] for i in N for j in N for k in K if i != j)
    z2 = quicksum(
        P2 * X[i, j, k] * distance[i, j] * f * (r1 + (r2 - r1) * D[i, k] / cap) for i in N for j in N for k in K if
        i != j)
    z3 = quicksum(
        P3 * X[i, j, k] * Q[i] * (1 - math.exp(-theta * TT[i, j] * 60)) for i in C for j in N for k in K if
        i != j)
    z4 = quicksum(P4 * X[i, j, k] * TT[i, j] * 60 for i in C for j in N for k in K if i != j)
    z5 = z2 * P5 * sigma
    # z6 =

    obj = [z1, z2, z3, z4, z5]

    model.setObjective(z1 + z2 + z3 + z4 + z5, GRB.MINIMIZE)
    # model.setObjective(z1, GRB.MINIMIZE)

    model.addConstrs(kpi[i] == obj[i] for i in range(5))
    # 车辆出入度=1
    model.addConstrs(quicksum(X[i, j, k] for i in depot for j in C) <= 1 for k in K)
    model.addConstrs(
        quicksum(X[i, j, k] for i in depot for j in N) == quicksum(X[i, j, k] for i in N for j in depot) for k in K)
    model.addConstrs(quicksum(X[i, j, k] for i in depot for j in depot if i != j) == 0 for k in K)
    model.addConstrs(
        quicksum(X[i, j, k] for j in N) == quicksum(X[j, i, k] for j in N) for i in depot for k in K)

    # 车辆连续约束
    model.addConstrs(
        quicksum(X[i, j, k] for j in N if j != i) == quicksum(X[j, i, k] for j in N if j != i) for i in C for k in K)
    # 保证所有需求点被服务
    model.addConstrs(quicksum(X[i, j, k] for k in K for j in N if j != i) == 1 for i in C)
    # 车辆容量约束
    model.addConstrs(quicksum(Q[i] * X[i, j, k] for i in C for j in N if i != j) <= cap for k in K)
    # 时间窗约束
    model.addConstrs(
        T[i, k] + ST[i] + TT[i, j] - (1 - X[i, j, k]) * M <= T[j, k] for i in C for j in C for k in K if i != j)
    model.addConstrs(T[i, k] >= ET[i] for i in N for k in K)
    model.addConstrs(T[i, k] <= LT[i] for i in N for k in K)
    # 运输量约束
    model.addConstrs(
        D[i, k] + Q[j] - (1 - X[i, j, k]) * M <= D[j, k] for i in C for j in C for k in K if i != j)
    model.addConstrs(D[i, k] <= cap for i in N for k in K)
    # model.addConstrs(D[i, k] >= Q[i] for i in N for k in K)
    # 车辆最大里程限   .
    model.addConstrs(quicksum(X[i, j, k] * distance[i, j] for i in N for j in N if i != j) <= 80 for k in K)
    # 设置模型参数
    model.Params.TimeLimit = 100
    # 模型求解
    model.optimize()
    if model.status == GRB.Status.OPTIMAL or model.status == GRB.Status.TIME_LIMIT:
        print(model.objVal)
        res = []
        for k in K:
            for i in N:
                for j in N:
                    if i != j:
                        if X[i, j, k].x > 0:
                            print(f"X[{i},{j},{k}]=1")
                            # res.append([i, j, k, T[i, k].x, T[j, k].x, D[i, k].x, D[j, k].x])
                            res.append([i, j, k])
        for i in range(5):
            print(f"第{i+1}个目标：{kpi[i].x}")
        return res
    else:
        print("no solution!!!")
        return []


def get_cmap(n, name='hsv'):
    """
    Returns a function that maps each index in 0, 1, ..., n-1 to a distinct
    RGB color; the keyword argument name must be a standard mpl colormap name.
    """
    return plt.cm.get_cmap(name, n)


def main():
    depot, C, N, Q, distance, n_vehicles, TT, ET, LT, ST, df1, df2 = get_data()
    res = buildModel(depot, C, N, Q, distance, n_vehicles, TT, ET, LT, ST)
    plt.scatter(df1.iloc[:, 0], df1.iloc[:, 1], marker="s", c="red")
    plt.scatter(df2.iloc[:, 0], df2.iloc[:, 1], c="black")
    if res:
        tmp = [r[2] for r in res]
        tmp = list(set(tmp))
        cmap = get_cmap(len(tmp))
        color = {tmp[k]: cmap(k) for k in range(len(tmp))}
        for i, j, k in res:
            if i < 0:
                plt.plot([df1.iloc[df1.shape[0] + i, 0], df2.iloc[j - 1, 0]],
                         [df1.iloc[df1.shape[0] + i, 1], df2.iloc[j - 1, 1]], c=color[k])
            elif j < 0:
                plt.plot([df2.iloc[i - 1, 0], df1.iloc[df1.shape[0] + j, 0]],
                         [df2.iloc[i - 1, 1], df1.iloc[df1.shape[0] + j, 1]], c=color[k])
            else:
                plt.plot([df2.iloc[i - 1, 0], df2.iloc[j - 1, 0]],
                         [df2.iloc[i - 1, 1], df2.iloc[j - 1, 1]], c=color[k])

    plt.show()


if __name__ == '__main__':
    main()
