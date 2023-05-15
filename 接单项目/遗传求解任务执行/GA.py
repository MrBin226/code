import numpy as np
import random
import matplotlib.pyplot as plt

plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文
np.random.seed(1)

class GA:
    # 模型参数
    PBG = 0.005
    PGB = 0.005
    RG = 100
    RB = 20
    E_R = (PBG * RG + PGB * RB) / (PBG + PGB)
    # f内元素的数量 = 虚拟机数量 + 1
    f = [0.1*(10**8), 0.2*(10**8), 0.201*(10**8), 0.202*(10**8), 0.203*(10**8), 0.204*(10**8)]
    # Ps的元素数量等于任务数
    Ps = np.random.uniform(10, 50, 30)
    Pr = 18
    Pm = 1500
    P0 = 10
    t_deadline = 50

    def __init__(self, task_num, virtual_machine_num, passageway_num, W, I_k, vm_pm,
                 start_num, end_num, execut_order, task_volume, input_data, out_data,
                 w_start, w_end, pop_size, select_rate, crossover_rate, mutate_rate,
                 max_iter=200):
        """
        初始化参数
        :param task_num:
        :param virtual_machine_num:
        :param passageway_num:
        :param W:
        :param I_k:
        :param vm_pm:
        :param start_num:
        :param end_num:
        :param execut_order:
        :param task_volume:
        :param input_data:
        :param out_data:
        :param w_start:
        :param w_end:
        :param pop_size: 种群大小
        :param select_rate: 选择概率
        :param crossover_rate: 交叉概率
        :param mutate_rate: 变异概率
        :param max_iter: 迭代次数
        """
        self.task_num = task_num
        self.virtual_machine_num = virtual_machine_num
        self.passageway_num = passageway_num
        self.W = W
        self.I_k = I_k
        self.vm_pm = vm_pm
        self.start_num = start_num
        self.end_num = end_num
        self.execut_order = execut_order
        self.task_volume = task_volume
        self.input_data = input_data
        self.out_data = out_data
        self.w_start = w_start
        self.w_end = w_end
        self.pop_size = pop_size
        self.select_rate = select_rate
        self.crossover_rate = crossover_rate
        self.mutate_rate = mutate_rate
        self.max_iter = max_iter
        # 初始化种群
        self.pop = self.init_pop()
        # 计算适应度
        self.fitness = self.cal_fitness(self.pop)

    def init_pop(self):
        # 初始化种群
        pop = np.zeros(shape=(self.pop_size, self.task_num, 2), dtype=int)
        pop[:, :, 0] = np.random.randint(0, self.virtual_machine_num + 1, size=(self.pop_size, self.task_num))
        for i in range(self.pop_size):
            for j in range(self.task_num):
                pop[i, j, 1] = self.select_pw(j, pop[i, j, 0])
            pop[i, :, :] = self.valid(pop[i, :, :])
        return pop

    def select_pw(self, task, execut_place):
        """
        通过任务和在哪个虚拟机上执行，选择一个使执行该任务能耗最低的通道
        :param task: 任务序号
        :param execut_place: 任务在哪执行
        :return: 最优通道
        """
        # 如果该任务在移动端执行，则无通道传输
        if execut_place == 0:
            return 0
        # 该任务在虚拟机指定通道上的传输速率
        pm = self.vm_pm[execut_place - 1]
        w = self.W[[i - 1 for i in pm]]
        i_k = self.I_k[[i - 1 for i in pm]]
        R = w * np.log2(1 + i_k * self.Ps[task])
        # 计算该任务在各个通道传输，最终的能耗
        E = self.P0 * self.task_volume[task] / self.f[execut_place] \
            + self.Ps[task] * self.input_data[task] / R + self.Pr * self.out_data[task] / R
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
                           + self.Ps[i] * self.input_data[i] / R + self.Pr * self.out_data[i] / R
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
                                      + (self.input_data[j] + self.out_data[j]) / R)
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
            if T <= self.t_deadline:
                # 如果小于截止时间
                f1 = 1
            else:
                # 如果大于截止时间
                f2 = 1
            fitness[kk] = f1 * E + 10 * f2 * T * E / self.t_deadline
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
                       + self.Ps[i] * self.input_data[i] / R + self.Pr * self.out_data[i] / R
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
                                  + (self.input_data[j] + self.out_data[j]) / R)
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
        new_pop[0, :, :] = self.pop[index[0], :, :]
        for i in range(1, parent_size):
            r1, r2 = np.random.randint(0, self.pop_size, size=(2, ))
            if self.fitness[r1] < self.fitness[r2]:
                new_pop[i, :, :] = self.pop[r1, :, :]
            else:
                new_pop[i, :, :] = self.pop[r2, :, :]
        return new_pop

    def crossover(self, parents):
        # 两点交叉
        parent_size = parents.shape[0]
        children = np.copy(parents)
        offering_size = int(np.floor(parent_size / 2))
        for i in range(offering_size):
            if random.random() < self.crossover_rate:
                cross_pos1 = np.random.randint(1, int(np.floor(self.task_num / 2)))
                cross_pos2 = np.random.randint(int(np.floor(self.task_num / 2)) + 1, self.task_num - 1)
                children[i * 2 - 1, cross_pos1:cross_pos2], children[i * 2, cross_pos1:cross_pos2] = \
                    parents[i * 2, cross_pos1:cross_pos2, :], parents[i * 2 - 1, cross_pos1:cross_pos2, :]
        return children

    def mutation(self, new_pop):
        # 单点变异
        parent_size = new_pop.shape[0]
        mutate_pop = np.copy(new_pop)
        for i in range(parent_size):
            for j in range(self.task_num):
                if random.random() < self.mutate_rate:
                    mutate_pop[i, j, 0] = np.random.randint(0, self.virtual_machine_num + 1)
                    mutate_pop[i, j, 1] = self.select_pw(j, mutate_pop[i, j, 0])
        return mutate_pop

    def valid(self, p):
        # 约束条件验证调整解
        for i in range(self.task_num):
            if p[i, 0] == 0:
                u = (self.input_data[i] + self.out_data[i]) / self.task_volume[i]
                v = self.E_R / self.f[0]
                if u < v:
                    p[i, 0] = np.random.randint(1, self.virtual_machine_num + 1)
                    p[i, 1] = self.select_pw(i, p[i, 0])
            else:
                u = (self.input_data[i] * self.Ps[i] + self.out_data[i] * self.Pr) / self.task_volume[i]
                v = self.E_R * self.Pm / self.f[0]
                if u >= v:
                    p[i, 0] = 0
                    p[i, 1] = 0
        return p

    def evolve(self):
        min_fitness = np.zeros(self.max_iter)   # 存储每一代最优个体的适应度值
        for m in range(self.max_iter):
            # 选择
            new_pop = self.select()
            # 交叉
            new_pop = self.crossover(new_pop)
            # 变异
            new_pop = self.mutation(new_pop)
            # 验证约束
            for i in range(new_pop.shape[0]):
                new_pop[i, :, :] = self.valid(new_pop[i, :, :])
            # 计算新一代种群的适应度
            new_fitness = self.cal_fitness(new_pop)
            # 将子代和父代放在一起，根据适应度值的大小，选出下一代种群
            all_pop = np.vstack((self.pop, new_pop))
            all_fit = np.hstack((self.fitness, new_fitness))
            index = np.argsort(all_fit)
            self.pop = all_pop[index[0:self.pop_size], :, :]
            self.fitness = all_fit[index[0:self.pop_size]]
            min_fitness[m] = min(self.fitness)
            print(f"迭代第{m + 1}次，最优适应度值为{min(self.fitness)}")
        idx = np.argsort(self.fitness)
        print("最优卸载计划（0代表移动端，1代表虚拟机1，2代表虚拟机2，3代表虚拟机3,...）：")
        T, E = self.cal_single_fit(self.pop[idx[0], :, :])
        print(f"所花费的时间为{round(T, 2)}，能耗为{round(E, 2)}")
        best_p = self.pop[idx[0], :, :]
        for i in range(self.task_num):
            print(f"任务{i + 1}：{'移动端执行' if best_p[i,0] == 0 else '虚拟机'+str(best_p[i,0])+'执行，通道号为'+str(best_p[i,1])}")
        self.draw(min_fitness)

    def draw(self, fits):
        plt.plot(range(self.max_iter), fits)
        plt.title("迭代变化过程")
        plt.xlabel("迭代次数")
        plt.ylabel("适应度值")
        plt.show()


if __name__ == '__main__':
    # 任务数（去除掉起始和终止任务，剩余任务的数量，因为起始和终止任务已经确定在移动端执行）
    task_num = 30
    # 虚拟机数量
    virtual_machine_num = 5
    # 通道数
    passageway_num = 10
    # 各个通道对应的带宽
    W = np.random.randint(10, 100, passageway_num)
    I_k = np.random.randint(10, 100, passageway_num)
    # 每个服务器对应的信道
    vm_pm = [[1], [2, 3, 4], [5, 6], [7, 8], [9, 10]]
    # 起始任务的数量
    start_num = 4
    # 终止任务的数量
    end_num = 1
    # 任务的执行次序
    # execut_order = np.array([1, 1, 2, 1, 1, 1, 2, 3, 4, 4, 4, 4, 5, 6, 7])
    execut_order = []
    execut_order.extend([i + 1] * 5 for i in range(int(task_num / 5)))
    execut_order.append([int(np.ceil(task_num / 5))] * (task_num - int(np.floor(task_num / 5)) * 5))
    execut_order = np.array([x for y in execut_order for x in y])
    # 任务工作量
    task_volume = [10, 50, 800, 400,10,
                  4,100, 5*10**4, 80, 40,
                  40,100, 500, 8, 40,
                  1000, 40,20,100,10,
                  50,40,100,10,20,
                  700,60,700,20,100]
    # 任务输入数据
    input_data = [100000, 20000, 1000, 3000, 1.5*10**4, 60, 9*10**4, 30, 90, 120,
                  200, 1*10**6, 5000, 300, 150, 6*10**5, 9*10**3, 3*10**3, 90,120,
                  2000, 1000, 50, 3*10**5, 150, 600,90, 300, 9*10**5, 1.5*10**6]
    # 任务输出数据
    out_data = [100000, 20000, 1000, 3000, 1.5*10**4, 60, 9*10**4, 30, 90, 120,
                  200, 1*10**6, 5000, 300, 150, 6*10**5, 9*10**3, 3*10**3, 90,120,
                  2000, 1000, 50, 3*10**5, 150, 600,90, 300, 9*10**5, 1.5*10**6]
    # 第一个任务的工作量
    w_start = np.random.randint(0.1 * (10 ** 8), 1 * (10 ** 8), start_num, dtype="int64")
    # 最后一个任务的工作量
    w_end = np.random.randint(0.1 * (10 ** 8), 1 * (10 ** 8), end_num, dtype="int64")
    # 种群数量
    pop_size = 100
    # 选择概率
    select_rate = 0.8
    # 交叉概率
    crossover_rate = 0.9
    # 变异概率
    mutate_rate = 0.1

    ga = GA(task_num, virtual_machine_num, passageway_num, W, I_k, vm_pm,
            start_num, end_num, execut_order,task_volume, input_data, out_data,
            w_start, w_end, pop_size, select_rate, crossover_rate, mutate_rate)
    ga.evolve()




