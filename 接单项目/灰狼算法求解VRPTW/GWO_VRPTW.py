import copy
import numpy as np
from geopy.distance import distance
import matplotlib.pyplot as plt


class GWO:

    def __init__(self, locations, time_windows, service_time, demands, depot, cap, speed):
        """

        :param locations: 需求点坐标
        :param time_windows: 时间窗
        :param demands: 需求
        :param service_time: 服务时间
        :param depot: 配送点坐标
        :param cap: 车辆最大容量
        :param speed: 车速
        :return:
        """
        self.speed = speed
        self.locations = locations
        self.time_windows = time_windows
        self.service_time = service_time
        self.demands = demands
        self.depot = depot
        self.cap = cap
        self.seq_dic = {i: i for i in range(1, len(self.demands) + 1)}

        self.process_demand()

        self.num_customers = len(self.demands)  # 顾客数

        self.dist_matrix = self._compute_distance_matrix()

        self.pop_size = 100  # 种群个数
        self.max_iter = 200  # 最大迭代次数

    def process_demand(self):
        k = len(self.demands) + 1
        reality_customers = len(self.demands)
        i = 0
        while i < reality_customers:
            if self.demands[i] > self.cap:
                self.demands[i] -= self.cap
                self.demands = np.append(self.demands, self.cap)
                self.locations = np.append(self.locations, self.locations[i].reshape(1, 2), axis=0)
                self.time_windows = np.append(self.time_windows, self.time_windows[i].reshape(1, 2), axis=0)
                self.service_time = np.append(self.service_time, self.service_time[i])
                self.seq_dic[k] = i + 1
                k += 1
            else:
                i += 1

    # 计算距离矩阵，根据经纬度计算距离
    def _compute_distance_matrix(self):
        dist_matrix = np.zeros((self.num_customers, self.num_customers))
        for i in range(self.num_customers):
            for j in range(self.num_customers):
                if i == j:
                    dist_matrix[i][j] = 0
                else:
                    dist_matrix[i][j] = distance(self.locations[i], self.locations[j]).km
        return dist_matrix

    # 验证方案是否可行，需求约束和时间窗
    def _feasible(self, routes):
        # 检查需求约束
        for route in routes:
            demand = sum([self.demands[i - 1] for i in route])
            if demand > self.cap:
                return False

        # 检查时间窗约束
        for route in routes:
            time = 0
            for idx, i in enumerate(route):
                if idx == 0:
                    time = distance(self.depot, self.locations[route[0] - 1]).km / self.speed
                else:
                    time += self.dist_matrix[route[idx - 1] - 1][i - 1] / self.speed
                # time = max(time, self.time_windows[i - 1][0])
                time += self.service_time[i - 1]
                if time > self.time_windows[i - 1][1]:
                    return False
        return True

    # 计算目标函数，即总距离最短
    def evaluate(self, routes):
        if not self._feasible(routes):
            return float('inf')
        else:
            cost = 0
            for route in routes:
                route_cost = distance(self.depot, self.locations[route[0] - 1]).km
                for idx, i in enumerate(route):
                    route_cost += self.dist_matrix[route[idx - 1] - 1][i - 1]
                route_cost += distance(self.depot, self.locations[route[-1] - 1]).km
                cost += route_cost
        return cost

    # 对灰狼个体进行解码，得到运输路线
    def decode(self, x):
        seq = np.argsort(x) + 1
        routes = []
        i = 0
        d = 0
        t = 0
        route = []
        while i < len(seq):
            if d == 0:
                t += distance(self.depot, self.locations[seq[i] - 1]).km / self.speed
            else:
                t += distance(self.locations[seq[i - 1] - 1], self.locations[seq[i] - 1]).km / self.speed
            d += self.demands[seq[i] - 1]
            if d > self.cap or t > self.time_windows[seq[i] - 1][1]:
                routes.append(route)
                d = 0
                t = 0
                route = []
                continue
            route.append(seq[i])
            i += 1
        return routes

    # 初始化灰狼个体
    def init_wolf(self):
        return np.random.uniform(-10, 10, size=(self.pop_size, self.num_customers))

    # 求解
    def solve(self):
        # 初始化种群
        pop = self.init_wolf()
        # 计算目标函数
        fitness = np.zeros(self.pop_size)
        for i in range(self.pop_size):
            routes = self.decode(pop[i])
            fitness[i] = self.evaluate(routes)
        pop = pop[np.argsort(fitness)]
        fitness.sort()
        alpha_wolf, beta_wolf, gamma_wolf = copy.copy(pop[: 3])

        convergence_curve = np.zeros(self.max_iter)  # 保存每次迭代的最优个体适应度
        # 开始迭代
        for Iter in range(1, self.max_iter + 1):
            a = 2 * (1 - Iter / self.max_iter)
            for i in range(self.pop_size):
                A1, A2, A3 = a * (2 * np.random.rand() - 1), a * (
                        2 * np.random.rand() - 1), a * (2 * np.random.rand() - 1)
                C1, C2, C3 = 2 * np.random.rand(), 2 * np.random.rand(), 2 * np.random.rand()
                X1 = alpha_wolf - A1 * abs(C1 - alpha_wolf - pop[i])
                X2 = beta_wolf - A2 * abs(C2 - beta_wolf - pop[i])
                X3 = gamma_wolf - A3 * abs(C3 - gamma_wolf - pop[i])
                x_new = (X1 + X2 + X3) / 3
                f_new = self.evaluate(self.decode(x_new))
                if f_new < fitness[i]:
                    pop[i] = x_new.copy()
                    fitness[i] = f_new
            pop = pop[np.argsort(fitness)]
            fitness.sort()
            alpha_wolf, beta_wolf, gamma_wolf = copy.copy(pop[: 3])
            convergence_curve[Iter - 1] = fitness[0]
            print(f"第{Iter}次迭代:目标值{fitness[0]}")
        return fitness[0], self.decode(alpha_wolf), convergence_curve, self.seq_dic


if __name__ == '__main__':
    import pandas as pd

    df = pd.read_excel("vrptw数据.xlsx")
    num_customers = 36  # 客户数量
    depot_location = np.array([24.212273, 109.338894])  # 车库位置
    customer_locations = df.iloc[:, 0].str.split(',').tolist()  # 客户位置
    customer_locations = np.array([list(map(float, i)) for i in customer_locations])
    customer_demands = df.iloc[:, 1].values  # 客户需求
    time_windows = df.iloc[:, 2].str.split('-').tolist()  # 客户时间窗口
    time_windows = np.array([list(map(int, i)) for i in time_windows])
    service_time = df.iloc[:, 3].values    # 服务时间
    cap = 13    # 车辆容量
    speed = 40  # 车速，KM/h

    # obj表示最优目标函数，routes表示最优方案，convergence_curve存储每次迭代的最优个体目标值
    obj, routes, convergence_curve, seq_dic = GWO(customer_locations, time_windows, service_time, customer_demands,
                                                  depot_location, cap, speed).solve()

    for i in range(len(routes)):
        for j in range(len(routes[i])):
            routes[i][j] = seq_dic[routes[i][j]]

    # 最优配送方案
    file = open("solution.txt", "w", encoding='utf-8')
    print(f"最优配送方案如下，总距离为{obj}, 共有{len(routes)}辆车：", file=file)
    for idx, route in enumerate(routes):
        print(f"第{idx + 1}辆车：{route}", file=file)

    plt.plot(range(len(convergence_curve)), convergence_curve)
    plt.xlabel("Iteration")
    plt.ylabel("distance")
    plt.savefig("迭代图像.png")
    plt.show()

