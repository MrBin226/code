import copy
import numpy as np
from scipy.integrate import quad


def f(x):
    return np.exp(x / 10)


class NSGA2:
    # 相关参数设置
    U = 12  # 用户人数
    N = 3  # BS数量
    T_gq = 0.5  # 计算kq的三个时间参数
    T_bq = 0.65
    T_avg = (T_gq + T_bq) / 2
    alpha = 1   # 计算kq的参数α
    E_0 = 1 # 计算Cq的参数
    E_rt = 0.5  # 计算Cq的参数
    epsilon = 0.6   # 计算e_q的参数
    P_c = 3.8   # 云BS的平均功率
    P_bs = 3.5  # BS的平均功率
    w_q = 1500 * 10**6  
    R_n = [60 * 10**9, 70 * 10**9, 80 * 10**9]
    R_c = 120 * 10**9
    I_q = 700
    H = 10
    coordinate_macro = np.random.randint(50, 200, size=(2, ))
    coordinate_u = np.random.randint(50, 200, size=(U, 2))  # 用户坐标
    coordinate_n = np.random.randint(100, 150, size=(N, 2))  # BS坐标
    delta = 9.9e-14  # δ_0平方
    g_0 = 20
    B = 0.2 * 10 ** 6
    p_macro = 3.6   # 用户到云BS的传输功率
    p_un = np.array([[3.99800349,3.99800303,3.99801109],
             [3.99799743, 3.99799819, 3.99801109],
             [3.99799509, 3.99799552, 3.99801109],
             [3.99799352, 3.99799306, 3.99800241],
             [3.99799352, 3.99799306, 3.99800241],
             [3.99799352, 3.99799306, 3.99800116],
             [3.99799352, 3.99799306, 3.99800116],
             [3.99799352, 3.99799306, 3.99800116],
             [3.99799352, 3.99799306, 3.99800116],
             [3.99799352, 3.99799306, 3.99800116],
             [3.99799352, 3.99799306, 3.99800116],
             [3.99799352, 3.99799306, 3.99800116]])

    def __init__(self, pop_num=50, max_iter=100, p_s=0.5, mutate_rate=0.2, r_m=0.7, eta=3):
        """

        :param pop_num: 种群大小
        :param max_iter: 最大迭代次数
        :param p_s: 选择操作的参数
        :param mutate_rate: 变异概率
        :param r_m: 变异操作里的参数
        :param eta: 变异操作里的参数
        """
        self.pop_num = pop_num
        self.max_iter = max_iter
        self.p_s = p_s
        self.mutate_rate = mutate_rate
        self.r_m = r_m
        self.eta = eta
        self.pop = self.init_pop()
        self.evolve()

    def init_pop(self):
        pop = []
        while True:
            # 初始化
            temp_pop = np.zeros((self.pop_num, self.U * 2))
            temp_pop[0:self.pop_num, 0:self.U] = np.random.randint(0, 2, (self.pop_num, self.U))
            for i in range(self.pop_num):
                idx = np.ravel(np.argwhere(temp_pop[i, 0:self.U] == 1) + self.U)
                temp_pop[i, idx] = np.random.randint(1, self.N + 1, len(idx))
            fitness = self.cal_fitness(temp_pop)
            # 计算非支配排序和拥挤距离，选择排名为1的个体
            indicate = self.get_rank_result(fitness)
            pop.extend(temp_pop[indicate, :].tolist())
            if len(pop) == self.pop_num:
                break
            if len(pop) > self.pop_num:
                del pop[self.pop_num: len(pop)]
                break
        return np.array(pop)

    def evolve(self):
        fitness = []
        for n_gen in range(1, self.max_iter):
            # 计算适应度
            fitness = self.cal_fitness(self.pop)
            # 计算非支配排序和拥挤距离，选择排名较高的个体
            indicate = self.get_rank_result(fitness, int(self.pop_num * self.p_s))
            # 复制排名较高个体
            self.pop = self.pop[indicate]
            fitness = fitness[indicate]
            count = 0
            while self.pop.shape[0] < self.pop_num:
                self.pop = np.r_[self.pop, [self.pop[count, :]]]
                fitness = np.r_[fitness, [fitness[count, :]]]
                count += 1
            # 交叉
            new_pop = self.cross_over(fitness)
            new_pop = self.correct(new_pop)
            # 变异
            new_pop = self.mutate(new_pop, n_gen)
            new_pop = self.correct(new_pop)
            new_fitness = self.cal_fitness(new_pop)
            # 合并选择后的个体以及交叉变异后的个体
            all_pop = np.vstack((self.pop, new_pop))
            all_fit = np.vstack((fitness, new_fitness))
            # 计算非支配排序和拥挤距离，选择更优个体进入下一代
            indicate = self.get_rank_result(all_fit, self.pop_num)
            self.pop = all_pop[indicate]
            print(f"第{n_gen}次迭代")
            if len(np.unique(self.pop, axis=0)) == 1:
                break
        indicate = self.get_rank_result(fitness)
        T, E = self.cal_fitness(self.pop[indicate][0].reshape((1, self.U * 2)), True)
        print("方案如下：")
        for i in range(self.U):
            if self.pop[indicate][0][i] == 1:
                print(f"第{i+1}个用户在第{int(self.pop[indicate][0][i+self.U])}个BS运行, 时间为{T[i]}, 能耗为{E[i]}")
            else:
                print(f"第{i + 1}个用户在云BS运行, 时间为{T[i]}, 能耗为{E[i]}")
        fit = self.cal_fitness(self.pop[indicate][0].reshape((1, self.U * 2)))
        print(f"RO目标值为{fit[0][0]}, RS目标值为{fit[0][1]}")

    def correct(self, pop):
        new_pop = pop.copy()
        for n in range(pop.shape[0]):
            idx = np.ravel(np.argwhere(new_pop[n, 0:self.U] == 0) + self.U)
            new_pop[n, idx] = 0
            idx = np.ravel(np.argwhere(new_pop[n, 0:self.U] == 1) + self.U)
            for i in idx:
                if new_pop[n, i] == 0:
                    new_pop[n, i] = 1
        return new_pop

    def mutate(self, new_pop, n_gen):
        for i in range(self.pop_num):
            r = np.random.rand()
            if r <= self.mutate_rate:
                p_max = np.repeat([1, self.N], self.U)
                p_min = np.repeat([0, 0], self.U)
                h = 1 - np.power(self.r_m, np.power(1 - n_gen / self.max_iter, self.eta))
                if np.random.rand() < 0.5:
                    new_pop[i, :] = np.round(new_pop[i, :] + (p_max - new_pop[i, :]) * h)
                else:
                    new_pop[i, :] = np.round(new_pop[i, :] + (new_pop[i, :] - p_min) * h)
                new_pop[i, np.ravel(np.argwhere(new_pop[i, 0:self.U] > 1))] = 1
                new_pop[i, np.ravel(np.argwhere(new_pop[i, 0:self.U] < 0))] = 0
                new_pop[i, np.ravel(np.argwhere(new_pop[i, self.U:self.U * 2] > self.N) + self.U)] = self.N
                new_pop[i, np.ravel(np.argwhere(new_pop[i, self.U:self.U * 2] < 0) + self.U)] = 0
        return new_pop

    def cross_over(self, fitness):
        # 将种群分为强弱两组
        pop = self.pop.copy()
        idx = set(range(self.pop_num))
        great_idx = set(self.get_rank_result(fitness, int(self.pop_num / 2)))
        less_idx = idx - great_idx
        great_pop = pop[list(great_idx)]
        great_fit = fitness[list(great_idx)]
        less_pop = pop[list(less_idx)]
        less_fit = fitness[list(less_idx)]
        f_max = np.max(fitness, axis=0)
        f_min = np.min(fitness, axis=0)
        for i in range(int(self.pop_num / 2)):
            if f_max[0] - f_min[0] == 0 or f_max[1] - f_min[1] == 0:
                xi_ta = np.abs(great_fit[i] - less_fit[i]) / (f_max - f_min)
                xi_ta[np.isnan(xi_ta)] = 0
            else:
                xi_ta = np.abs(great_fit[i] - less_fit[i]) / (f_max - f_min)
            if np.any(np.isnan(xi_ta)):
                a=1
            xi_ta = np.repeat(xi_ta, self.U)
            d = np.zeros(self.U * 2)
            for j in range(self.U * 2):
                r = np.random.rand()
                if r >= 0.5:
                    d[j] = 0
                else:
                    d[j] = less_pop[i, j] - great_pop[i, j]
            great_pop[i] = np.round(great_pop[i] + xi_ta * d)
            less_pop[i] = np.round(less_pop[i] + xi_ta * d)
            great_pop[i, np.ravel(np.argwhere(great_pop[i, 0:self.U] > 1))] = 1
            great_pop[i, np.ravel(np.argwhere(great_pop[i, 0:self.U] < 0))] = 0
            less_pop[i, np.ravel(np.argwhere(less_pop[i, 0:self.U] > 1))] = 1
            less_pop[i, np.ravel(np.argwhere(less_pop[i, 0:self.U] < 0))] = 0
            great_pop[i, np.ravel(np.argwhere(great_pop[i, self.U:self.U * 2] > self.N) + self.U)] = self.N
            great_pop[i, np.ravel(np.argwhere(great_pop[i, self.U:self.U * 2] < 0) + self.U)] = 0
            less_pop[i, np.ravel(np.argwhere(less_pop[i, self.U:self.U * 2] > self.N) + self.U)] = self.N
            less_pop[i, np.ravel(np.argwhere(less_pop[i, self.U:self.U * 2] < 0) + self.U)] = 0
        return np.r_[great_pop, less_pop]

    def get_rank_result(self, fitness, nN=None):
        r_dict = self.dominance(fitness)
        layerDict = self.rank(r_dict)
        s = 0
        indicate = []
        if nN is None:
            nN = len(layerDict[1])
        for i in range(1, len(layerDict) + 1):
            s += len(layerDict[i])
            if s < nN:
                indicate.extend(layerDict[i])
                continue
            elif s == nN:
                indicate.extend(layerDict[i])
                break
            else:
                s -= len(layerDict[i])
                temp = self.crowddist(fitness, layerDict[i])
                indicate.extend(temp[:nN - s])
                break
        return indicate

    def cal_fitness(self, pop, flag=False):
        fitness = np.zeros((self.pop_num, 2))
        num = pop.shape[0]
        for k in range(num):
            k_q = np.zeros(self.U)
            c_q = np.zeros(self.U)
            e_q = np.zeros(self.U)
            tt = np.zeros(self.U)
            ee = np.zeros(self.U)
            for i in range(self.U):
                if pop[k, i] == 1:
                    v_u = self.B * np.log2(1 + self.p_un[i, int(pop[k, i + self.U] - 1)]
                                           * self.cal_gama(i, self.p_un, int(pop[k, i + self.U])))
                    if type(v_u) is not np.float64:
                        a=1
                    t_up = self.I_q / v_u
                    t_pro = self.w_q / self.R_n[int(pop[k, i + self.U]) - 1]
                    E_pro = self.P_bs * t_pro
                else:
                    v_u = self.B * np.log2(1 + self.p_macro
                                           * self.cal_gama(i, self.p_macro, 0))
                    t_up = self.I_q / v_u
                    t_pro = self.w_q / self.R_c
                    E_pro = self.P_c * t_pro
                t_q = t_up + t_pro
                tt[i] = t_q
                ee[i] = E_pro
                if t_q > self.T_bq:
                    k_q[i] = 0
                if self.T_avg < t_q <= self.T_bq:
                    k_q[i] = 1 / (1 + np.exp(self.alpha * (t_q - self.T_avg) / (self.T_bq - self.T_avg)))
                if self.T_gq < t_q <= self.T_avg:
                    k_q[i] = 1 / (1 + np.exp(self.alpha * (self.T_avg - t_q) / (self.T_avg - self.T_gq)))
                if t_q < self.T_gq:
                    k_q[i] = 1
                c_q[i] = quad(f, self.E_0 - self.E_rt, self.E_0 - self.E_rt + E_pro)[0]
                e_q[i] = self.epsilon * k_q[i] + (1 - self.epsilon) * E_pro
            if flag:
                return tt, ee
            fitness[k, 0] = np.sum((1 - pop[k, 0:self.U]) * e_q)
            fitness[k, 1] = np.sum(pop[k, 0:self.U] * (k_q - c_q))
        return fitness

    def cal_g_un(self, u, n, flag=True):
        if n == 0 and flag:
            g_un = self.g_0 / (np.sum((self.coordinate_u[u, :] - self.coordinate_macro) ** 2) + self.H ** 2)
        else:
            g_un = self.g_0 / (np.sum((self.coordinate_u[u, :] - self.coordinate_n[n, :]) ** 2) + self.H ** 2)
        return g_un

    def cal_gama(self, u, p_un, n):
        g_un = self.cal_g_un(u, n - 1, False)
        temp = 0
        for i in range(self.U):
            if i == u:
                continue
            else:
                if n == 0:
                    temp += p_un * self.cal_g_un(i, n)
                else:
                    temp += p_un[i, n - 1] * self.cal_g_un(i, n - 1, False)
        gama = g_un / (self.delta + temp)
        return gama

    @staticmethod
    def crowddist(funScore, indicate):
        # 求出该层　评分子矩阵
        indicate = np.array(indicate)
        score = funScore[indicate]

        # 求出集合中 不同属性的 范围
        # rangeVector=np.array([1.0, 1.0])
        maxVector = np.max(funScore, axis=0)
        minVector = np.min(funScore, axis=0)
        rangeVector = (maxVector - minVector) * 1.0

        # 生成个体编号
        N = score.shape[0]
        V = score.shape[1]
        indicateVector = np.arange(N)
        indicateVectorT = indicateVector.reshape(N, 1)

        # 生成 函数值和个体序号 矩阵
        dist = np.array([0.0] * N * V).reshape(N, V)
        scoreIndicateMatrix = np.hstack((score, indicateVectorT))

        scoreList = scoreIndicateMatrix.tolist()

        for i in range(V):
            scoreList.sort(key=lambda x: x[i])

            i_a = int(scoreList[0][-1])
            i_b = int(scoreList[-1][-1])
            dist[i_a][i] = 1000000000000000
            dist[i_b][i] = 1000000000000000

            for j in range(1, N - 1):
                c = scoreList[j - 1][i]
                d = scoreList[j + 1][i]
                i_e = int(scoreList[j][-1])
                dist[i_e][i] = d - c

        distVector = np.sum(dist / rangeVector, axis=1)

        dist_indicate = indicate[np.argsort(distVector)].tolist()

        return dist_indicate[::-1]

    @staticmethod
    def dominance(funScore):
        # 支配关系字典
        r_dict = {}

        # 需要建立支配关系的 个体数
        N = funScore.shape[0]

        # 建立个体索引 向量
        indicateVector = np.arange(N)

        # 建立 元素全为1 的 列向量
        oneVector = np.array([1] * N).reshape(N, 1)

        for k in range(N):
            # 建立 行向量全为 第k个个体评分的 矩阵
            oneMatrix = oneVector * funScore[k,]

            # 建立支配关系判断的 差分矩阵
            diffMatrix = funScore - oneMatrix

            greaterMatrix = np.vstack((diffMatrix[:, 0] >= 0, diffMatrix[:, 1] <= 0)).T
            lessMatrix = np.vstack((diffMatrix[:, 0] <= 0, diffMatrix[:, 1] >= 0)).T
            equalMatrix = (diffMatrix == 0)

            greaterVector = np.all(greaterMatrix, axis=1)
            lessVector = np.all(lessMatrix, axis=1)
            equalVector = np.all(equalMatrix, axis=1)

            # 建立非支配、支配向量
            dominate = indicateVector[greaterVector ^ equalVector,]
            nonDominate = indicateVector[lessVector ^ equalVector,]

            # 建立支配关系字典
            r_dict[k] = [len(nonDominate), list(dominate)]

        return r_dict

    @staticmethod
    def rank(r_dict):
        # 拷贝 支配关系字典
        r_dict = copy.deepcopy(r_dict)

        # 支配集分层, 层号初始化
        i = 1

        # 分层字典 layerDict
        layerDict = {}

        while r_dict != {}:
            # 取出当前种群非支配个体，放入第i层
            layerDict[i] = []

            # 找出当前非支配个体
            for k, v in r_dict.items():
                if v[0] == 0:
                    layerDict[i].append(k)

            ###将被 第i层支配的个体 支配数减1
            for k in layerDict[i]:
                # val[0] 支配 k 的个体数
                # val[1] 个体 k 支配的个体列表
                val = r_dict.pop(k)
                for v in val[1]:
                    r_dict[v][0] -= 1

            i = i + 1

        return layerDict


if __name__ == '__main__':
    NSGA2()