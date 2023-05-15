import numpy as np
import random
import matplotlib.pyplot as plt
from PI import PI
from s_num import s_num
from task_vol import task_vol
import math

plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文
# 让随机种子等于1，其实相当于每次运行产生的随机数都相等
np.random.seed(1)

class GA:
    # 模型参数
    PBG = 0.05
    PGB = 0.05
    RG = 100
    RB = 5
    E_R = (PBG * RG + PGB * RB) / (PBG + PGB)
    # f内元素的数量 = 虚拟机数量 + 1
    f = [1 * (10 ** 5), 1.5 * (10 ** 5), 1.6 * (10 ** 5), 1.7 * (10 ** 5), 1.8 * (10 ** 5), 1.6 * (10 ** 5),
         1.7 * (10 ** 5), 1.8 * (10 ** 5), 1.7 * (10 ** 5), 1.4 * (10 ** 5), 1.2 * (10 ** 5),
         1.7 * (10 ** 5), 1.8 * (10 ** 5), 1.7 * (10 ** 5), 1.4 * (10 ** 5), 1.2 * (10 ** 5),
         1.7 * (10 ** 5), 1.8 * (10 ** 5), 1.7 * (10 ** 5), 1.4 * (10 ** 5), 1.2 * (10 ** 5),
         1.7 * (10 ** 5), 1.8 * (10 ** 5), 1.7 * (10 ** 5), 1.4 * (10 ** 5), 1.2 * (10 ** 5),
         1.7 * (10 ** 5), 1.8 * (10 ** 5), 1.7 * (10 ** 5), 1.4 * (10 ** 5), 1.2 * (10 ** 5)]
    Ps = PI.PI120
    Pm = 5
    P0 = 0.1
    t_deadline = 4
    # # 初始化种群
    # pop = self.init_pop()
    # # 计算适应度
    # fitness = self.cal_fitness(self.pop)

    def __init__(self, task_num, server_num, passageway_num, W, I_k, vm_pm,
                 start_num, end_num, execut_order, task_volume, s,
                 w_start, w_end, pop_size, select_rate,
                 max_iter=100):
        """
        初始化参数
        :param task_num:
        :param server_num:
        :param passageway_num:
        :param W:
        :param I_k:
        :param vm_pm:
        :param start_num:
        :param end_num:
        :param execut_order:
        :param task_volume:
        :param s:
        :param w_start:
        :param w_end:
        :param pop_size: 种群大小
        :param select_rate: 选择概率
        :param max_iter: 迭代次数
        """
        self.task_num = task_num
        self.server_num = server_num
        self.passageway_num = passageway_num
        self.W = W
        self.I_k = I_k
        self.vm_pm = vm_pm
        self.start_num = start_num
        self.end_num = end_num
        self.execut_order = execut_order
        self.task_volume = task_volume
        self.s = s
        self.w_start = w_start
        self.w_end = w_end
        self.pop_size = pop_size
        self.select_rate = select_rate
        self.crossover_rate1 = 0.9
        self.crossover_rate2 = 0.6
        self.mutate_rate1 = 0.1
        self.mutate_rate2 = 0.001
        # self.average_fit = None
        self.max_iter = max_iter
        # # 初始化种群
        self.pop = self.init_pop()
        # # 计算适应度
        self.fitness = self.cal_fitness(self.pop)
        self.avg_fitness = np.mean(self.fitness)    # 初始种群的平均适应度
        self.max_fitness = np.max(self.fitness)     # 初始种群的最大适应度

    # def func(self):
    #     # 初始化种群
    #     self.pop = self.init_pop()
    #     # 计算适应度
    #     self.fitness = self.cal_fitness(self.pop)
    #     return self.fitness

    def init_pop(self):
        # 初始化种群
        pop = np.zeros(shape=(self.pop_size, self.task_num, 2), dtype=np.int)
        pop[:, :, 0] = np.random.randint(0, self.server_num + 1, size=(self.pop_size, self.task_num))
        for i in range(self.pop_size):
            for j in range(self.task_num):
                pop[i, j, 1] = self.select_pw(j, pop[i, j, 0])
            pop[i, :, :] = self.valid(pop[i, :, :])
        # for i in range(self.pop_size):
        #     self.average_fit[i,:]= self.pop[i,:].fitness / self.max_iter
        #     if self.pop[i,:].fitness <= self.average_fit[i,:]:
        #         self.crossover_rate = self.crossover_rate1 - (self.crossover_rate1 - self.crossover_rate2) * \
        #                               (self.pop[i,:].fitness - self.average_fit[i,:]) / (self.average_fit[i,:] - self.fitness)
        #         self.mutate_rate = self.mutate_rate1 - (self.mutate_rate1 - self.mutate_rate2) * \
        #                            (self.pop[i,:].fitness - self.average_fit[i,:]) / (self.average_fit[i,:] - self.fitness)
        #     else:
        #         self.crossover_rate = self.crossover_rate1
        #         self.mutate_rate = self.mutate_rate1
        return pop

    def select_pw(self, task, execut_place):
        """
        通过任务和在哪个虚拟机上执行，选择一个使执行该任务能耗最低的通道
        :param task: 任务序号
        :param execut_place: 任务在哪执行
        :return: 最优通道
        """
        # 如果该任务在移动端执行，则无通道传输
        if execut_place.any() == 0:
            return 0
        # 该任务在虚拟机指定通道上的传输速率
        pm = self.vm_pm[execut_place - 1]
        W = self.W[[i - 1 for i in pm]]
        i_k = self.I_k[[i - 1 for i in pm]]
        R = W * np.log2(1 + i_k * self.Ps[task])
        # 计算该任务在各个通道传输，最终的能耗
        E = self.P0 * self.task_volume[task] / self.f[execut_place] \
            + self.Ps[task] * self.s[task] / R
        return pm[np.argmin(E)]

    def cal_fitness(self, pop, flag=False):
        """
        :param pop: 种群全部个体的任务卸载计划
        :param flag: 是否返回计算时间和能耗（True返回）
        :return: 默认返回适应度
        """

        cal_size = pop.shape[0]
        fitness = np.zeros(cal_size)
        for kk in range(cal_size):
            pp = pop[kk,:,:]
            p, q = pp[:, 0], pp[:, 1]
            E_m = 0
            E_c = 0
            t_start = 0
            t_start += max(self.w_start / self.f[0])  # 起始任务中的最大时间
            E_m += sum(self.Pm * self.w_start / self.f[0])  # 起始任务所有功耗加起来
            for i in range(self.task_num):
                # 计算传输速率
                if p[i] == 0:
                    # 该任务在移动端
                    E_m += self.Pm * self.task_volume[i] / self.f[0]
                else:
                    R = self.W[q[i] - 1] * np.log2(1 + self.I_k[q[i] - 1] * self.Ps[i])
                    # 该任务在云服务器
                    E_c += self.P0 * self.task_volume[i] / self.f[p[i]] \
                           + self.Ps[i] * self.s[i] / R
            # 获取这些任务被分为几组，即去除重复元素
            all_num = np.unique(self.execut_order)
            for i in all_num:
                # 获取第i组的任务所在索引
                task = np.where(self.execut_order == i)[0]
                # 保存第i组的任务执行时间
                t_each = []
                for j in task:
                    if p[j] == 0:
                        t_each.append(self.task_volume[j] / self.f[0])
                    else:
                        R = self.W[q[j] - 1] * np.log2(1 + self.I_k[q[j] - 1] * self.Ps[j])
                        t_each.append(self.task_volume[j] / self.f[p[j]]
                                      + self.s[j] / R)
                t_start += max(t_each)
            # 再加上最后任务的计算时间
            T = t_start + max(self.w_end / self.f[0])
            # 再加上最后任务的能耗
            E_m += sum(self.Pm * self.w_end / self.f[0])
            # 总能耗
            E = E_m + E_c
            if flag:
                return T, E
            f1, f2 = 0, 0
            l = 1*10**(-0.1)
            if T <= self.t_deadline:
                # 如果小于截止时间
                f1 = 1
            else:
                # 如果大于截止时间
                f2 = 1
            fitness[kk] = f1 * E +f2*(E+l*(T-self.t_deadline))
        return fitness

    def cal_single_fit(self, pp):
        """
        计算单个个体的适应度
        :param pp: 一个个体的卸载计划
        :return: 花费的时间T和能耗E
        """
        p, q = pp[:, 0], pp[:, 1]
        E_m = 0
        E_c = 0
        t_start = 0
        t_start += max(self.w_start / self.f[0])  # 起始任务中的最大时间
        E_m += sum(self.Pm * self.w_start / self.f[0])  # 起始任务所有功耗加起来
        for i in range(self.task_num):
            # 计算传输速率
            if p[i] == 0:
                # 该任务在移动端
                E_m += self.Pm * self.task_volume[i] / self.f[0]
            else:
                R = self.W[q[i] - 1] * np.log2(1 + self.I_k[q[i] - 1] * self.Ps[i])
                # 该任务在云服务器
                E_c += self.P0 * self.task_volume[i] / self.f[p[i]] \
                       + self.Ps[i] * self.s[i] / R
        # 获取这些任务被分为几组，即去除重复元素
        all_num = np.unique(self.execut_order)
        for i in all_num:
            # 获取第i组的任务所在索引
            task = np.where(self.execut_order == i)[0]
            # 保存第i组的任务执行时间
            t_each = []
            for j in task:
                if p[j] == 0:
                    t_each.append(self.task_volume[j] / self.f[0])
                else:
                    R = self.W[q[j] - 1] * np.log2(1 + self.I_k[q[j] - 1] * self.Ps[j])
                    t_each.append(self.task_volume[j] / self.f[p[j]]
                                  + self.s[j] / R)
            t_start += max(t_each)
        # 再加上最后任务的计算时间
        T = t_start + max(self.w_end / self.f[0])
        # 再加上最后任务的能耗
        E_m += sum(self.Pm * self.w_end / self.f[0])
        # 总能耗
        E = E_m + E_c
        return T, E

    def select(self):
        # 二元锦标赛选择结合精英策略（保存每代中的最优个体）
        index = np.argsort(self.fitness)
        parent_size = int(np.floor(self.pop_size * self.select_rate))
        new_pop = np.zeros(shape=(parent_size, self.task_num, 2), dtype=int)
        select_fitness = np.zeros(parent_size)
        new_pop[0, :, :] = self.pop[np.array(index)[0], :, :]
        select_fitness[0] = self.fitness[np.array(index)[0]]
        print(np.array(index)[0])
        for i in range(1, parent_size):
            r1, r2 = np.random.randint(0, self.pop_size, size=(2, ))
            if self.fitness[r1] < self.fitness[r2]:
                new_pop[i, :, :] = self.pop[r1, :, :]
                select_fitness[i] = self.fitness[r1]
            else:
                new_pop[i, :, :] = self.pop[r2, :, :]
                select_fitness[i] = self.fitness[r2]
        return new_pop, select_fitness

    def crossover(self, parents, parents_fitness):
        # 两点交叉
        parent_size = parents.shape[0]
        children = np.copy(parents)
        offering_size = int(np.floor(parent_size / 2))
        for i in range(offering_size):
            f_1 = max([parents_fitness[i * 2 - 1], parents_fitness[i * 2]])
            if self.avg_fitness > f_1:
                crossover_rate = self.crossover_rate1
            else:
                crossover_rate = self.crossover_rate1 - (self.crossover_rate1 - self.crossover_rate2) * \
                                 (f_1 - self.avg_fitness) / (self.max_fitness - self.avg_fitness)
            if random.random() < crossover_rate:
                cross_pos1 = np.random.randint(1, int(np.floor(self.task_num / 2)))
                cross_pos2 = np.random.randint(int(np.floor(self.task_num / 2)) + 1, self.task_num - 1)
                children[i * 2 - 1, cross_pos1:cross_pos2], children[i * 2, cross_pos1:cross_pos2] = \
                    parents[i * 2, cross_pos1:cross_pos2, :], parents[i * 2 - 1, cross_pos1:cross_pos2, :]
        return children

    def mutation(self, new_pop):
        # 单点变异
        parent_size = new_pop.shape[0]
        mutate_pop = np.copy(new_pop)
        new_fitness = self.cal_fitness(new_pop)
        for i in range(parent_size):
            if new_fitness[i] < self.avg_fitness:
                mutate_rate = self.mutate_rate1
            else:
                mutate_rate = self.mutate_rate1 - (self.mutate_rate1 - self.mutate_rate2) * \
                              (new_fitness[i] - self.avg_fitness) / (self.max_fitness - self.avg_fitness)
            for j in range(self.task_num):
                if random.random() < mutate_rate:
                    mutate_pop[i, j, 0] = np.random.randint(0, self.server_num + 1)
                    mutate_pop[i, j, 1] = self.select_pw(j, mutate_pop[i, j, 0])
        return mutate_pop

    def valid(self, p):
        # 约束条件验证调整解
        dis1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                2, 5, 7, 3, 9, 11, 8, 10, 10, 2,
                1, 2, 3, 6, 6, 6, 7, 8, 4, 10]
        dis2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                2, 5, 7, 3, 9, 11, 8, 10, 10, 2,
                1, 2, 3, 6, 6, 6, 7, 8, 4, 10]
        BS1 = [100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200,
               210, 220, 230, 240, 250, 100, 110, 120, 130, 140, 150,
               130, 140, 200, 190, 200, 220, 250, 270, 300, 190, 180]
        BS2 = [100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200,
               210, 220, 230, 240, 250, 100, 110, 120, 130, 140, 150,
               130, 140, 200, 190, 200, 220, 250, 270, 300, 190, 180]
        Ps = PI.PI120
        distance = 0
        for i in range(self.server_num):
            distance = math.sqrt(math.pow((dis1[i] - BS1[i]), 2) + math.pow((dis2[i] - BS2[i]), 2))
        d = np.array(distance)
        for i in range(self.task_num):
            I = 200
            if any(I_k * Ps[i]) >= I and d < 300:
                if p[i, 0] == 0:
                    u = self.s[i] / self.task_volume[i]
                    v = self.E_R / self.f[0]
                    if u < v:
                        p[i, 0] = np.random.randint(1, self.server_num + 1)
                        p[i, 1] = self.select_pw(i, p[i, 0])
                else:
                    u = self.s[i] * self.Ps[i] / self.task_volume[i]
                    v = self.E_R * self.Pm / self.f[0]
                    if u >= v:
                        p[i, 0] = 0
                        p[i, 1] = 0
        return p

    def evolve(self):
        min_fitness = np.zeros(self.max_iter)   # 存储每一代最优个体的适应度值
        for m in range(self.max_iter):
            # 选择
            pop, select_fitness = self.select()
            # 交叉
            new_pop = self.crossover(pop, select_fitness)
            # 变异
            new_pop = self.mutation(new_pop)
            new_pop = self.valid(new_pop)
            pop = self.valid(pop)
            for i in range(new_pop.shape[0]):
                for j in range(self.task_num):
                    new_pop[i, j, 1] = self.select_pw(j, new_pop[i, j, 0])
            for i in range(pop.shape[0]):
                for j in range(self.task_num):
                    pop[i, j, 1] = self.select_pw(j, pop[i, j, 0])
            # # 交叉变异之后粒子与交叉变异前的粒子谁更优保留谁
            # new_fit = self.cal_fitness(new_pop)
            # fit = self.cal_fitness(pop)
            # a = new_fit.any()
            # if new_fit.any() < fit.any():
            #     self.fitness = new_fit
            #     self.pop = new_pop
            # else:
            #     self.fitness = fit
            #     self.pop = pop
            # 计算新一代种群的适应度
            new_fitness = self.cal_fitness(new_pop)
            # 将子代和父代放在一起，根据适应度值的大小，选出下一代种群
            all_pop = np.vstack((self.pop, new_pop))
            all_fit = np.hstack((self.fitness, new_fitness))
            index = np.argsort(all_fit)
            self.pop = all_pop[index[0:self.pop_size], :, :]
            self.fitness = all_fit[index[0:self.pop_size]]
            min_fitness[m] = min(self.fitness)
            self.avg_fitness = np.mean(self.fitness)
            self.max_fitness = np.max(self.fitness)
            # self.crossover_rate = 0.9 - self.dff_crossover_rate * m / self.max_iter
            # self.mutate_rate = 0.1 + self.add_mutate_rate * m / self.max_iter
            print(f"迭代第{m + 1}次，最优适应度值为{min(self.fitness)}")
        idx = np.argsort(self.fitness)
        print("最优卸载计划（0代表移动端，1代表服务器1，2代表服务器2，3代表服务器3,...）：")
        T, E = self.cal_single_fit(self.pop[np.array(idx)[0], :, :])
        print(f"所花费的时间为{round(T, 2)}，能耗为{round(E, 2)}")
        best_p = self.pop[np.array(idx)[0], :, :]
        for i in range(self.task_num):
            print(f"任务{i + 1}：{'移动端执行' if best_p[i,0] == 0 else '服务器'+str(best_p[i,0])+'执行，信道为'+str(best_p[i,1])}")
        self.draw(min_fitness)

    def draw(self, fits):
        plt.plot(range(self.max_iter), fits)
        plt.title("迭代变化过程")
        plt.xlabel("迭代次数")
        plt.ylabel("适应度值")
        plt.show()


if __name__ == '__main__':
    # 任务数（去除掉起始和终止任务，剩余任务的数量，因为起始和终止任务已经确定在移动端执行）
    task_num = 120
    # 服务器数量
    server_num = 30
    # 通道数
    passageway_num = 35
    # 各个通道对应的带宽
    W = np.array(
        [0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.1 * 10 ** 6,
         0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6,
         0.1 * 10 ** 6, 0.1 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.1 * 10 ** 6,
         0.1 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6,
         0.1 * 10 ** 6, 0.4 * 10 ** 6, 0.2 * 10 ** 6, 0.6 * 10 ** 6, 0.2 * 10 ** 6, 0.1 * 10 ** 6, 0.2 * 10 ** 6,
         0.1 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6,
         0.2 * 10 ** 6, 0.3 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6, 0.2 * 10 ** 6])
    I_k = np.array(
        [0.51 * 10 ** 2, 1 * 10 ** 2, 0.21 * 10 ** 2, 0.41 * 10 ** 2, 0.22 * 10 ** 2, 0.31 * 10 ** 2, 1 * 10 ** 2,
         1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2,
         0.41 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 0.11 * 10 ** 2, 0.11 * 10 ** 2,
         1 * 10 ** 2, 0.5 * 10 ** 2, 1 * 10 ** 2,
         0.35 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 0.11 * 10 ** 2, 1 * 10 ** 2,
         0.3 * 10 ** 2, 1 * 10 ** 2,
         1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2, 1 * 10 ** 2])
    # 每个服务器对应的信道
    vm_pm = [[1], [2, 3], [4, 5], [6], [7], [8], [9], [10], [11, 12], [13], [14], [15],
             [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26, 27], [28], [29], [30], [31], [32], [33],
             [34, 35]]
    # 起始任务的数量
    start_num = 1
    # 终止任务的数量
    end_num = 1
    execut_order = []
    execut_order.extend([i + 1] * 10 for i in range(int(task_num / 10)))
    execut_order.append([int(np.ceil(task_num / 10))] * (task_num - int(np.floor(task_num / 10)) * 10))
    execut_order = np.array([x for y in execut_order for x in y])
    # 任务工作量
    task_volume = list(task_vol.task_vol120)
    # 任务输入数据
    s = s_num.s_num120
    # 第一个任务的工作量
    w_start = np.random.randint(10, 11, start_num, dtype="int64")
    # 最后一个任务的工作量
    w_end = np.random.randint(10, 11, end_num, dtype="int64")
    # 种群数量
    pop_size = 100
    # 选择概率
    select_rate = 0.8
    # 交叉概率
    crossover_rate = 0.9
    # 变异概率
    mutate_rate = 0.1

    ga = GA(task_num, server_num, passageway_num, W, I_k, vm_pm,
            start_num, end_num, execut_order,task_volume, s,
            w_start, w_end, pop_size, select_rate)
    ga.evolve()