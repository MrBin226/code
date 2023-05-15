import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# 粒子类
class Particle:

    def __init__(self, pos, fitness, speed, best_pos, best_fitness):
        """

        :param pos: 粒子当前位置
        :param fitness: 粒子当前适应度
        :param speed: 粒子当前速度
        :param best_pos: 粒子历史最优位置
        :param best_fitness: 粒子历史最优适应度
        """
        self.pos = pos
        self.fitness = fitness
        self.speed = speed
        self.best_pos = best_pos
        self.best_fitness = best_fitness


# sigmoid激活函数
def sigmoid(x):
    return 1 / (1 + np.exp(-x))


# 绘制迭代图像
def draw(fit):
    plt.plot(range(len(fit)), fit)
    plt.xlabel("Iteration")
    plt.ylabel("MSE")


# 获取数据（只取了一个excel文件的500多条数据）
def get_data(filename):
    df = pd.read_excel(filename, sheet_name="Sheet2", skiprows=[0, 1],
                       usecols=[24, 25, 26, 27, 28], header=None)
    df.columns = ["maxT", "minT", "Rhmean", "time", "ETO"]
    df = df.dropna()
    data = df.values
    t = int(data.shape[0] * 0.7)
    x_train = data[0:t, 0:4]
    y_train = data[0:t, 4]
    x_test = data[t:data.shape[0], 0:4]
    y_test = data[t:data.shape[0], 4]
    return x_train, y_train, x_test, y_test


# elm算法进行预测
def elm_predict(x_test, w, b, beta):
    H = sigmoid(np.dot(x_test, w) + b)
    Y_out = np.dot(H, beta)
    return Y_out


# 数据归一化处理
def normalization(x, y):
    x_min = x.min(axis=1)
    x_max = x.max(axis=1)
    y_min = y.min()
    y_max = y.max()
    x_s = x.copy()
    y_s = y.copy()
    for i in range(x.shape[0]):
        x_s[i, :] = 2 * (x[i, :] - x_min[i]) / (x_max[i] - x_min[i]) - 1
        y_s[i] = 2 * (y[i] - y_min) / (y_max - y_min) - 1
    return x_s, x_max, x_min, y_s, y_max, y_min


# 数据反归一化
def back_normalize(y, y_max, y_min):
    y_s = y.copy()
    for i in range(len(y)):
        y_s[i] = (y[i] + 1) * (y_max - y_min) / 2 + y_min
    return y_s


# 算法类
class PSO:

    def __init__(self, input_num, hidden_num, outdim, Xtrain, Ytrain, particle_num=30, c1=1.5, c2=1.5,
                 w_s=0.8, w_e=0.4, max_iter=100, min_error=0.0005):
        """

        :param particle_num: 粒子数量
        :param c1: 学习因子
        :param c2:
        :param w_s: 初始惯性权重
        :param w_e: 终止惯性权重
        :param max_iter: 最大迭代次数
        :param input_num: 输入层维度
        :param hidden_num: 隐含层维度
        :param min_error: 最小迭代误差
        :param outdim: 输出层维度
        :param Xtrain: 输入数据
        :param Ytrain: 输出数据
        """
        self.input_num = input_num
        self.hidden_num = hidden_num
        self.outdim = outdim
        self.Xtrain = Xtrain
        self.Ytrain = Ytrain
        self.particle_num = particle_num
        self.c1 = c1
        self.c2 = c2
        self.w_s = w_s
        self.w_e = w_e
        self.max_iter = max_iter
        self.min_error = min_error
        self.particles, self.best_fitness, self.best_position = \
            self.init_particle()

    # 初始化参数
    def init_particle(self):
        particles = []
        v = 2 * np.random.rand(self.particle_num, (self.input_num + 1) * self.hidden_num) - 1
        x = 2 * np.random.rand(self.particle_num, (self.input_num + 1) * self.hidden_num) - 1
        for i in range(self.particle_num):
            fit = self.cal_fitness(x[i, :])
            particles.append(Particle(x[i, :], fit, v[i, :], x[i, :], fit))
        best_fitness = particles[0].fitness
        best_position = particles[0].pos
        for i in range(1, self.particle_num):
            if particles[i].fitness < best_fitness:
                best_fitness = particles[i].fitness
                best_position = particles[i].pos
        return particles, best_fitness, best_position

    # 计算适应度，即均方误差
    def cal_fitness(self, x):
        w = np.reshape(x[0:self.input_num*self.hidden_num], (self.input_num, self.hidden_num))
        b = x[self.input_num*self.hidden_num:(self.input_num + 1) * self.hidden_num]
        H = sigmoid(np.dot(self.Xtrain, w) + b)
        beta = np.dot(np.linalg.pinv(H), self.Ytrain)
        Y_out = np.dot(H, beta)
        return np.sum((Y_out - self.Ytrain) ** 2) / len(self.Ytrain)

    def evolve(self):
        iter = 1
        min_f = []
        while (iter <= self.max_iter) and (self.best_fitness >= self.min_error):
            w_n = self.w_s - (self.w_s - self.w_e) * float(iter) / self.max_iter
            for i in range(self.particle_num):
                self.particles[i].speed = w_n * self.particles[i].speed + self.c1 * (self.particles[i].best_pos -
                                         self.particles[i].pos) + self.c2 * (self.best_position - self.particles[i].pos)
                self.particles[i].pos = self.particles[i].pos + self.particles[i].speed
                self.particles[i].fitness = self.cal_fitness(self.particles[i].pos)
                if self.particles[i].fitness < self.particles[i].best_fitness:
                    self.particles[i].best_pos = self.particles[i].pos
                    self.particles[i].best_fitness = self.particles[i].fitness
            for i in range(self.particle_num):
                if self.particles[i].fitness < self.best_fitness:
                    self.best_fitness = self.particles[i].fitness
                    self.best_position = self.particles[i].pos
            print(f"迭代第{iter}次，最优适应度值为{self.best_fitness}")
            min_f.append(self.best_fitness)
            iter += 1
        draw(min_f)

    # 获取最优参数
    def get_result(self):
        w = np.reshape(self.best_position[0:self.input_num * self.hidden_num], (self.input_num, self.hidden_num))
        b = self.best_position[self.input_num * self.hidden_num:(self.input_num + 1) * self.hidden_num]
        H = sigmoid(np.dot(self.Xtrain, w) + b)
        beta = np.dot(np.linalg.pinv(H), self.Ytrain)
        return w, b, beta


if __name__ == '__main__':
    # 获取数据
    p_x_train, p_y_train, p_x_test, p_y_test = get_data("51463乌鲁木齐ET0库.xlsx")
    # 归一化
    x_train, x_train_max, x_train_min, y_train, y_train_max, y_train_min = normalization(p_x_train, p_y_train)
    x_test, x_test_max, x_test_min, y_test, y_test_max, y_test_min = normalization(p_x_test, p_y_test)
    # 迭代优化
    pso = PSO(4, 6, 1, x_train, y_train)
    pso.evolve()
    # 获取最终的参数
    w, b, beta = pso.get_result()
    # 进行预测
    y_out = elm_predict(x_test, w, b, beta)
    # 反归一化
    p_y_out = back_normalize(y_out, y_test_max, y_test_min)
    # 性能评价
    MAE = np.sum(np.abs(p_y_test - p_y_out)) / len(p_y_test)  # 平均绝对误差
    RMSE = np.sqrt(np.sum((p_y_test - p_y_out) ** 2) / len(p_y_test))   # 均方根误差
    y_mean = np.mean(p_y_test)
    R_2 = 1 - np.sum((p_y_test - p_y_out) ** 2) / np.sum((p_y_test - y_mean) ** 2)    # 决定系数
    print(f"预测天数为{len(p_y_test)}天,各评价指标如下：")
    print(f"MAE={MAE}, RMSE={RMSE}, R^2={R_2}")
    plt.show()




