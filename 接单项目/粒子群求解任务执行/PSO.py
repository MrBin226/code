import numpy as np
import random
import matplotlib.pyplot as plt

plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文

# 让随机种子等于1，其实相当于每次运行产生的随机数都相等
np.random.seed(1)

class Particle:
    """
    粒子类
    pos：粒子的当前位置
    fitness：粒子的当前适应度
    speed：粒子的速度
    global_pos：粒子的历史最优位置
    global_fitness：粒子的历史最优适应度
    """
    def __init__(self, pos, fitness, speed, global_pos, global_fitness):
        self.pos = pos
        self.fitness = fitness
        self.speed = speed
        self.global_pos = global_pos
        self.global_fitness = global_fitness


class PSO:

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
    # R = 100
    # 自适应学习因子
    c1, c2 = 2, 2
    # 惯性权重
    w_max, w_min = 0.9, 0.4

    def __init__(self, task_num, virtual_machine_num, passageway_num, W, I_k, vm_pm, start_num, end_num, execut_order, particle_num, task_volume, input_data, out_data, w_start, w_end, MaxIter=200):
        """
        初始化参数
        :param task_num: 任务数量
        :param virtual_machine_num: 虚拟机数量
        :param passageway_num: 通道数量
        :param W: 各个通道对应的带宽
        :param vm_pm: 各个虚拟机对应的信道
        :param start_num: 起始任务数量
        :param end_num: 终止任务数量
        :param execut_order: 任务的执行次序
        :param particle_num: 粒子数
        :param task_volume: 任务的工作量
        :param input_data: 任务的输入数据
        :param out_data: 任务的输出数据
        :param w_start: 第一个任务的工作量
        :param w_end: 最后一个任务的工作量
        :param MaxIter: 最大迭代次数
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
        self.particle_num = particle_num
        self.MaxIter = MaxIter
        self.task_volume = task_volume
        self.input_data = input_data
        self.out_data = out_data
        self.w_start = w_start
        self.w_end = w_end
        self.crossover_rate = 0.9   # 交叉概率
        self.mutate_rate = 0.1  # 变异概率
        self.particles = []  # 存储所有的粒子
        self.dim = 2    # 表示粒子是二维的
        # 全局最优位置和适应度
        self.best_position, self.best_fitness = self.init_pop()

    def init_pop(self):
        """
        初始化种群
        :return: 全局最优位置和适应度
        """
        # 随机初始化粒子位置（第一维：0代表移动端，1代表虚拟机1，2代表虚拟机2，3代表虚拟机3；第二维（对于在移动端执行的任务，无通道，使用0进行表示）：1表示通道1，2表示通道2，...）
        position = np.zeros(shape=(self.particle_num, self.task_num, 2), dtype=int)
        position[:, :, 0] = np.random.randint(0, self.virtual_machine_num+1, size=(self.particle_num, self.task_num))
        for i in range(self.particle_num):
            for j in range(self.task_num):
                position[i, j, 1] = self.select_pw(j, position[i, j, 0])
        # 初始速度为0
        speed = np.zeros(shape=(self.particle_num, self.task_num, 2))
        for i in range(self.particle_num):
            # 验证约束，不满足则更新
            position[i, :] = self.valid(position[i, :, :])
            # 计算适应度
            fitness = self.cal_fitness(position[i, :, :])
            self.particles.append(Particle(position[i, :], fitness, speed[i, :], position[i, :], fitness))
        best_position, best_fitness = self.particles[0].pos, self.particles[0].fitness
        for particle in self.particles:
            if particle.fitness < best_fitness:
                best_position, best_fitness = particle.pos, particle.fitness
        return best_position, best_fitness

    def cal_fitness(self, pp, flag=False):
        """
        :param pp: 任务卸载计划
        :param flag: 是否返回计算时间和能耗（True返回）
        :return: 默认返回适应度
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
                # t_start += self.task_volume[i] / self.f[0]
            else:
                R = W[q[i] - 1] * np.log2(1 + I_k[q[i] - 1] * self.Ps[i])
                # 该任务在云服务器
                E_c += self.P0 * self.task_volume[i] / self.f[p[i]] \
                       + self.Ps[i] * self.input_data[i] / R + self.Pr * self.out_data[i] / R
                # t_start += self.task_volume[i] / self.f[p[i]] \
                #            + (self.input_data[i] + self.out_data[i]) / self.R
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
                    R = W[q[j] - 1] * np.log2(1 + I_k[q[j] - 1] * self.Ps[j])
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
        fitness = f1 * E + 10 * f2 * T * E / self.t_deadline
        return fitness

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

    def crossover(self, pos1, pos2):
        # 两点交叉
        new_pos = np.copy(pos1)
        if random.random() < self.crossover_rate:
            cross_pos1 = np.random.randint(1, int(np.floor(self.task_num / 2)))
            cross_pos2 = np.random.randint(int(np.floor(self.task_num / 2)) + 1, self.task_num - 1)
            new_pos[cross_pos1:cross_pos2] = pos2[cross_pos1:cross_pos2, :]
        return new_pos

    def mutation(self, pos):
        # 单点变异
        new_pos = np.copy(pos)
        for j in range(self.task_num):
            if random.random() < self.mutate_rate:
                new_pos[j, 0] = np.random.randint(0, self.virtual_machine_num + 1)
                new_pos[j, 1] = self.select_pw(j, new_pos[j, 0])
        return new_pos

    def updata_Particle(self, w):
        """

        :param w: 惯性权重
        :return: 更新前的粒子历史最优适应度
        """
        # 更新前的粒子历史最优适应度
        pre_fit = [0 for _ in range(self.particle_num)]
        for i in range(self.particle_num):
            particle = self.particles[i]
            # 保存更新前的粒子历史最优适应度
            pre_fit[i] = particle.global_fitness
            # 速度更新
            particle.speed = w * particle.speed + self.c1 * random.random() * (particle.global_pos - particle.pos) \
                + self.c2 * random.random() * (self.best_position - particle.pos)
            # 对速度进行取整
            particle.speed = np.round(particle.speed).astype("int")
            # 位置更新
            pos = particle.pos + particle.speed
            # 让超出界限的值限定在范围内
            p, q = pos[:, 0], pos[:, 1]
            p[p < 0] = 0
            p[p > self.virtual_machine_num] = self.virtual_machine_num
            for j in range(self.task_num):
                if p[j] == 0:
                    q[j] = 0
                else:
                    MAX = max(self.vm_pm[p[j] - 1])
                    MIN = min(self.vm_pm[p[j] - 1])
                    if q[j] > MAX:
                        q[j] = MAX
                    if q[j] < MIN:
                        q[j] = MIN
            pos = np.vstack((p, q)).T
            # 交叉
            new_pos = self.crossover(pos, self.best_position)
            # 变异
            new_pos = self.mutation(new_pos)
            # 验证约束
            new_pos = self.valid(new_pos)
            pos = self.valid(pos)
            # 根据在哪个虚拟机执行，选取当前最优的那个通道
            for j in range(self.task_num):
                new_pos[j, 1] = self.select_pw(j, new_pos[j, 0])
                pos[j, 1] = self.select_pw(j, pos[j, 0])
            # 看交叉变异之后粒子与交叉变异前的粒子谁更优保留谁
            new_fit = self.cal_fitness(new_pos)
            fit = self.cal_fitness(pos)
            if new_fit < fit:
                particle.fitness = new_fit
                particle.pos = new_pos
            else:
                particle.fitness = fit
                particle.pos = pos
            # 更新粒子历史最优位置和适应度
            if particle.fitness < particle.global_fitness:
                particle.global_pos = particle.pos
                particle.global_fitness = particle.fitness
            self.particles[i] = particle
        return pre_fit

    def evolve(self):
        w = 0
        s_t = [0 for _ in range(self.particle_num)]
        # 保存每次迭代的全局最优适应度
        fits = [0 for _ in range(self.MaxIter)]
        for i in range(self.MaxIter):
            if i > 0:
                # 计算惯性权重
                w = (self.w_max - self.w_min) * sum(s_t) / self.particle_num + self.w_min
            # 更新粒子
            pre_fit = self.updata_Particle(w)
            # 保存迭代前的全局最优适应度
            pre_global_fit = self.best_fitness
            for idx, particle in enumerate(self.particles):
                # 更新全局最优位置和适应度
                if particle.fitness < self.best_fitness:
                    self.best_position = particle.pos
                    self.best_fitness = particle.fitness
                # 计算s_t
                if particle.global_fitness < pre_fit[idx]:
                    if particle.global_fitness < pre_global_fit:
                        s_t[idx] = 1
                    else:
                        s_t[idx] = 0.5
                else:
                    s_t[idx] = 0
            fits[i] = self.best_fitness
            print(f"迭代第{i+1}次，最优适应度值为{self.best_fitness}")
        print("最优卸载计划（0代表移动端，1代表虚拟机1，2代表虚拟机2，3代表虚拟机3,...）：")
        T, E = self.cal_fitness(self.best_position, flag=True)
        print(f"所花费的时间为{round(T, 2)}，能耗为{round(E, 2)}")
        for i in range(self.task_num):
            print(f"任务{i + 1}：{'移动端执行' if self.best_position[i,0] == 0 else '虚拟机'+str(self.best_position[i,0])+'执行，通道号为'+str(self.best_position[i,1])}")
        self.draw(fits)

    def draw(self, fits):
        plt.plot(range(self.MaxIter), fits)
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
    pso = PSO(task_num, virtual_machine_num, passageway_num, W, I_k, vm_pm, start_num, end_num, execut_order, 10, task_volume, input_data, out_data, w_start, w_end)
    pso.evolve()



