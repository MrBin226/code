import numpy as np
from sklearn.svm import SVC
from sklearn.model_selection import cross_val_score
import random
import matplotlib.pyplot as plt


# 1.加载数据load_data

def load_data(data_file):
    '''导入训练数据
    input:  data_file(string):训练数据所在文件
    output: data(mat):训练样本的特征
            label(mat):训练样本的标签
    '''
    data = []
    label = []
    # temp = np.loadtxt("WFs1.csv", delimiter=',', skiprows=1)
    # data = temp[:,1:]
    # label = temp[:,0]
    f = open(data_file)

    for line in f.readlines():
        lines = line.strip().split(' ')
        # lines = line.strip().split(',')
        # 提取得出label
        label.append(float(lines[0]))
        # 提取出特征，并将其放入到矩阵中
        index = 0
        tmp = []
        for i in range(1, len(lines)):
            li = lines[i].strip().split(":")
            # li = lines[i].strip().split(".")

            if int(li[0]) - 1 == index:
                tmp.append(float(li[1]))
            else:
                while (int(li[0]) - 1 > index):
                    tmp.append(0)
                    index += 1
                tmp.append(float(li[1]))
            index += 1
        while len(tmp) < 13:
            tmp.append(0)
        data.append(tmp)
    f.close()
    return np.array(data), np.array(label).T

trainX,trainY = load_data(r'rbf_data')

## MPSO优化算法
class MPSO(object):
    def __init__(self, particle_num, particle_dim, iter_num, c1, c2, w_max, w_min, max_value, min_value):
        '''参数初始化
        particle_num(int):粒子群的粒子数量
        particle_dim(int):粒子维度，对应待寻优参数的个数
        iter_num(int):最大迭代次数
        c1(float):局部学习因子，表示粒子移动到该粒子历史最优位置(pbest)的加速项的权重
        c2(float):全局学习因子，表示粒子移动到所有粒子最优位置(gbest)的加速项的权重
        w_max(float):最大惯性因子，表示粒子之前运动方向在本次方向上的惯性
        w_min(float):最小惯性因子
        max_value(float):参数的最大值
        min_value(float):参数的最小值
        '''
        self.particle_num = particle_num
        self.particle_dim = particle_dim
        self.iter_num = iter_num
        self.c1 = c1  ##通常设为2.0
        self.c2 = c2  ##通常设为2.0
        self.w_max = w_max
        self.w_min = w_min
        self.max_value = max_value
        self.min_value = min_value
        self.v_max = 0.5 * (max_value - min_value)  # 最大速度
        self.r = random.random()  # 初始混沌数

    ### 2.1 粒子群初始化
    def swarm_origin(self):
        '''粒子群初始化
        input:self(object):PSO类
        output:particle_loc(list):粒子群位置列表
               particle_dir(list):粒子群方向列表
        '''
        particle_loc = []
        particle_dir = []
        for i in range(self.particle_num):
            tmp1 = []
            tmp2 = []
            for j in range(self.particle_dim):
                a = random.random()  # 产生随机浮点数
                b = random.random()
                tmp1.append(a * (self.max_value - self.min_value) + self.min_value)
                tmp2.append(-self.v_max + 2 * self.v_max * b)
            particle_loc.append(tmp1)
            particle_dir.append(tmp2)

        return particle_loc, particle_dir

    ## 2.2 计算适应度函数数值列表;初始化pbest_parameters和gbest_parameter
    def fitness(self, particle_loc):
        '''计算适应度函数值
        input:self(object):PSO类
              particle_loc(list):粒子群位置列表
        output:fitness_value(list):适应度函数值列表
        '''
        fitness_value = []
        ### 1.适应度函数为RBF_SVM的3_fold（3折）交叉校验平均值
        for i in range(self.particle_num):
            rbf_svm = SVC(kernel='rbf', C=particle_loc[i][0], gamma=particle_loc[i][1])  # svm的使用函数
            cv_scores = cross_val_score(rbf_svm, trainX, trainY, cv=3, scoring='accuracy')
            fitness_value.append(cv_scores.mean())
        ### 2. 当前粒子群最优适应度函数值和对应的参数
        current_fitness = 0.0
        current_parameter = []
        for i in range(self.particle_num):
            if current_fitness < fitness_value[i]:
                current_fitness = fitness_value[i]
                current_parameter = particle_loc[i]

        return fitness_value, current_fitness, current_parameter

    ## 2.3  粒子位置更新
    def updata(self, t, particle_loc, particle_dir, gbest_parameter, mbest_parameter, pbest_parameters, fitness_value):
        '''粒子群位置更新
        input:self(object):PSO类
              t:当前迭代次数
              particle_loc(list):粒子群位置列表
              particle_dir(list):粒子群方向列表
              gbest_parameter
              mbest_parameter(list):粒子群各个维度的平均参数
              pbest_parameters(list):每个粒子的历史最优值
              fitness_value:每个粒子的适应度值

        output:particle_loc(list):新的粒子群位置列表
               particle_dir(list):新的粒子群方向列表
        '''
        self.r = 4 * self.r * (1 - self.r)
        w = self.r * self.w_min + (self.w_max - self.w_min) * t / self.iter_num
        mean_fit = np.mean(fitness_value)
        ## 1.计算新的量子群方向和粒子群位置
        for i in range(self.particle_num):
            a1 = [x * w for x in particle_dir[i]]
            a2 = [y * self.c1 * random.random() for y in
                  list(np.array(pbest_parameters[i]) - np.array(particle_loc[i]))]
            a3 = [z * self.c2 * random.random() for z in list(np.array(mbest_parameter) - np.array(particle_dir[i]))]
            dire = np.array(a1) + np.array(a2) + np.array(a3)
            dire[dire > self.v_max] = self.v_max
            dire[dire < -self.v_max] = -self.v_max
            particle_dir[i] = list(dire)
            #            particle_dir[i] = self.w * particle_dir[i] + self.c1 * random.random() * (pbest_parameters[i] - particle_loc[i]) + self.c2 * random.random() * (gbest_parameter - particle_dir[i])
            if np.exp(fitness_value[i]) / np.exp(mean_fit) > random.random():
                particle_loc[i] = list(
                    np.array(particle_loc[i]) * w + (1 - w) * np.array(particle_dir[i]) + np.array(gbest_parameter))
            else:
                particle_loc[i] = list(np.array(particle_loc[i]) + np.array(particle_dir[i]))

        ## 2.将更新后的量子位置参数固定在[min_value,max_value]内
        ### 2.1 每个参数的取值列表
        parameter_list = []
        for i in range(self.particle_dim):
            tmp1 = []
            for j in range(self.particle_num):
                tmp1.append(particle_loc[j][i])  # 锁定粒子,num[j],dim[i]
            parameter_list.append(tmp1)

        ### 2.2 每个参数取值的最大值、最小值、平均值
        value = []
        for i in range(self.particle_dim):
            tmp2 = []
            tmp2.append(max(parameter_list[i]))
            tmp2.append(min(parameter_list[i]))
            value.append(tmp2)

        for i in range(self.particle_num):
            for j in range(self.particle_dim):
                particle_loc[i][j] = (particle_loc[i][j] - value[j][1]) / (value[j][0] - value[j][1]) * (
                            self.max_value - self.min_value) + self.min_value

        return particle_loc, particle_dir

    ## 2.5 主函数
    def main(self):
        '''主函数
        '''
        results = []
        best_fitness = 0.0
        ## 1、粒子群初始化
        particle_loc, particle_dir = self.swarm_origin()
        # print(particle_loc)
        # print("_____________________________________________________")
        # print(particle_dir)
        # 2、初始化gbest_parameter、pbest_parameters、fitness_value列表
        ## 2.1 gbest_parameter,全局最优值，由于需要优化两个参数，因此初始化为[0.0 , 0.0]
        gbest_parameter = []
        for i in range(self.particle_dim):
            gbest_parameter.append(0.0)

        ### 2.2 pbest_parameters，个体局部最优值，因此初始化为[[0.0 , 0.0],[0.0 , 0.0] ......[0.0 , 0.0]]
        pbest_parameters = []
        for i in range(self.particle_num):
            tmp1 = []
            for j in range(self.particle_dim):
                tmp1.append(0.0)
            pbest_parameters.append(tmp1)

        ### 2.3 fitness_value，适应值
        fitness_value = []
        for i in range(self.particle_num):
            fitness_value.append(0.0)

        ## 3.迭代
        for i in range(self.iter_num):
            print(i)
            ### 3.1 计算当前适应度函数值列表
            current_fitness_value, current_best_fitness, current_best_parameter = self.fitness(particle_loc)
            ### 3.2 求当前的gbest_parameter、pbest_parameters和best_fitness
            u = np.random.randint(0, self.particle_num, 2)
            for j in range(self.particle_num):
                temp = [current_fitness_value[u[0]], current_fitness_value[u[1]]]
                idx = np.argmin(temp)
                if current_fitness_value[j] > fitness_value[j]:
                    if current_fitness_value[idx] > current_fitness_value[j]:
                        pbest_parameters[j] = particle_loc[idx]
                    else:
                        pbest_parameters[j] = particle_loc[j]  # 局部历史最优值
            if current_best_fitness > best_fitness:
                best_fitness = current_best_fitness
                gbest_parameter = current_best_parameter  # 全局最优值
            # print('-----------------迭代数与最优值--------------------')
            # print('iteration is :', i + 1, ';Best parameters:', gbest_parameter, ';Best fitness', best_fitness)
            results.append(best_fitness)
            ### 3.3 更新fitness_value
            fitness_value = current_fitness_value
            ### 3.4 更新粒子群
            mbest_parameter = np.mean(np.array(particle_loc), axis=0)
            particle_loc, particle_dir = self.updata(i + 1, particle_loc, particle_dir, gbest_parameter,
                                                     mbest_parameter, pbest_parameters, fitness_value)
        ## 4.结果展示
        results.sort()
        return results, gbest_parameter

# PSO算法
class PSO(object):
    def __init__(self, particle_num, particle_dim, iter_num, c1, c2, w, max_value, min_value):
        '''参数初始化
        particle_num(int):粒子群的粒子数量
        particle_dim(int):粒子维度，对应待寻优参数的个数
        iter_num(int):最大迭代次数
        c1(float):局部学习因子，表示粒子移动到该粒子历史最优位置(pbest)的加速项的权重
        c2(float):全局学习因子，表示粒子移动到所有粒子最优位置(gbest)的加速项的权重
        w(float):惯性因子，表示粒子之前运动方向在本次方向上的惯性
        max_value(float):参数的最大值
        min_value(float):参数的最小值
        '''
        self.particle_num = particle_num
        self.particle_dim = particle_dim
        self.iter_num = iter_num
        self.c1 = c1  ##通常设为2.0
        self.c2 = c2  ##通常设为2.0
        self.w = w
        self.max_value = max_value
        self.min_value = min_value

    ### 2.1 粒子群初始化
    def swarm_origin(self):
        '''粒子群初始化
        input:self(object):PSO类
        output:particle_loc(list):粒子群位置列表
               particle_dir(list):粒子群方向列表
        '''
        particle_loc = []
        particle_dir = []
        for i in range(self.particle_num):
            tmp1 = []
            tmp2 = []
            for j in range(self.particle_dim):
                a = random.random()  # 产生随机浮点数
                b = random.random()
                tmp1.append(a * (self.max_value - self.min_value) + self.min_value)
                tmp2.append(b)
            particle_loc.append(tmp1)
            particle_dir.append(tmp2)

        return particle_loc, particle_dir

    ## 2.2 计算适应度函数数值列表;初始化pbest_parameters和gbest_parameter
    def fitness(self, particle_loc):
        '''计算适应度函数值
        input:self(object):PSO类
              particle_loc(list):粒子群位置列表
        output:fitness_value(list):适应度函数值列表
        '''
        fitness_value = []
        ### 1.适应度函数为RBF_SVM的3_fold（3折）交叉校验平均值
        for i in range(self.particle_num):
            rbf_svm = SVC(kernel='rbf', C=particle_loc[i][0], gamma=particle_loc[i][1])  # svm的使用函数
            cv_scores = cross_val_score(rbf_svm, trainX, trainY, cv=3, scoring='accuracy')
            fitness_value.append(cv_scores.mean())
        ### 2. 当前粒子群最优适应度函数值和对应的参数
        current_fitness = 0.0
        current_parameter = []
        for i in range(self.particle_num):
            if current_fitness < fitness_value[i]:
                current_fitness = fitness_value[i]
                current_parameter = particle_loc[i]

        return fitness_value, current_fitness, current_parameter

    ## 2.3  粒子位置更新
    def updata(self, particle_loc, particle_dir, gbest_parameter, pbest_parameters):
        '''粒子群位置更新
        input:self(object):PSO类
              particle_loc(list):粒子群位置列表
              particle_dir(list):粒子群方向列表
              gbest_parameter(list):全局最优参数
              pbest_parameters(list):每个粒子的历史最优值
        output:particle_loc(list):新的粒子群位置列表
               particle_dir(list):新的粒子群方向列表
        '''
        ## 1.计算新的量子群方向和粒子群位置
        for i in range(self.particle_num):
            a1 = [x * self.w for x in particle_dir[i]]
            a2 = [y * self.c1 * random.random() for y in
                  list(np.array(pbest_parameters[i]) - np.array(particle_loc[i]))]
            a3 = [z * self.c2 * random.random() for z in list(np.array(gbest_parameter) - np.array(particle_dir[i]))]
            particle_dir[i] = list(np.array(a1) + np.array(a2) + np.array(a3))
            #            particle_dir[i] = self.w * particle_dir[i] + self.c1 * random.random() * (pbest_parameters[i] - particle_loc[i]) + self.c2 * random.random() * (gbest_parameter - particle_dir[i])
            particle_loc[i] = list(np.array(particle_loc[i]) + np.array(particle_dir[i]))

        ## 2.将更新后的量子位置参数固定在[min_value,max_value]内
        ### 2.1 每个参数的取值列表
        parameter_list = []
        for i in range(self.particle_dim):
            tmp1 = []
            for j in range(self.particle_num):
                tmp1.append(particle_loc[j][i])  # 锁定粒子,num[j],dim[i]
            parameter_list.append(tmp1)

        ### 2.2 每个参数取值的最大值、最小值、平均值
        value = []
        for i in range(self.particle_dim):
            tmp2 = []
            tmp2.append(max(parameter_list[i]))
            tmp2.append(min(parameter_list[i]))
            value.append(tmp2)

        for i in range(self.particle_num):
            for j in range(self.particle_dim):
                particle_loc[i][j] = (particle_loc[i][j] - value[j][1]) / (value[j][0] - value[j][1]) * (
                            self.max_value - self.min_value) + self.min_value

        return particle_loc, particle_dir

    ## 2.5 主函数
    def main(self):
        '''主函数
        '''
        results = []
        best_fitness = 0.0
        ## 1、粒子群初始化
        particle_loc, particle_dir = self.swarm_origin()
        # print(particle_loc)
        # print("_____________________________________________________")
        # print(particle_dir)
        # 2、初始化gbest_parameter、pbest_parameters、fitness_value列表
        ## 2.1 gbest_parameter,全局最优值，由于需要优化两个参数，因此初始化为[0.0 , 0.0]
        gbest_parameter = []
        for i in range(self.particle_dim):
            gbest_parameter.append(0.0)

        ### 2.2 pbest_parameters，个体局部最优值，因此初始化为[[0.0 , 0.0],[0.0 , 0.0] ......[0.0 , 0.0]]
        pbest_parameters = []
        for i in range(self.particle_num):
            tmp1 = []
            for j in range(self.particle_dim):
                tmp1.append(0.0)
            pbest_parameters.append(tmp1)

        ### 2.3 fitness_value，适应值
        fitness_value = []
        for i in range(self.particle_num):
            fitness_value.append(0.0)

        ## 3.迭代
        for i in range(self.iter_num):
            print(i)
            ### 3.1 计算当前适应度函数值列表
            current_fitness_value, current_best_fitness, current_best_parameter = self.fitness(particle_loc)
            ### 3.2 求当前的gbest_parameter、pbest_parameters和best_fitness
            for j in range(self.particle_num):
                if current_fitness_value[j] > fitness_value[j]:
                    pbest_parameters[j] = particle_loc[j]  # 局部历史最优值
            if current_best_fitness > best_fitness:
                best_fitness = current_best_fitness
                gbest_parameter = current_best_parameter  # 全局最优值
            # sg.cprint('-----------------迭代数与最优值--------------------')
            # sg.cprint('iteration is :', i + 1, ';Best parameters:', gbest_parameter, ';Best fitness', best_fitness)
            results.append(best_fitness)
            ### 3.3 更新fitness_value
            fitness_value = current_fitness_value
            ### 3.4 更新粒子群
            particle_loc, particle_dir = self.updata(particle_loc, particle_dir, gbest_parameter, pbest_parameters)
        ## 4.结果展示
        results.sort()
        return results, gbest_parameter

if __name__ == '__main__':
    particle_num = 100  # 100
    particle_dim = 2
    iter_num = 50  # 200  0.8407
    c1 = 0.2
    c2 = 0.5
    w_max = 0.9
    w_min = 0.4
    max_value = 15
    min_value = 0.001
    # ----------------PSO_RBF_SVM-----------------
    pso1 = MPSO(particle_num, particle_dim, iter_num, c1, c2, w_max, w_min, max_value, min_value)
    results1, gbest_parameter1 = pso1.main()
    pso2 = PSO(particle_num, particle_dim, iter_num, c1, c2, 0.8, max_value, min_value)
    results2, gbest_parameter2 = pso2.main()
    print('MPSO Final parameters are :', gbest_parameter1)
    print('PSO Final parameters are :', gbest_parameter2)
    print('MPSO best fitness are :', results1[-1])
    print('PSO best fitness are :', results2[-1])
    fig = plt.figure(figsize=(12,8))
    plt.plot(range(len(results1)), results1, color='red', label="MPSO-SVM")
    plt.plot(range(len(results2)), results2, color='blue', label="PSO-SVM")
    plt.xlabel("Number of iteration")
    plt.ylabel("Value of CV")
    plt.title("MPSO_RBF_SVM and PSO_RBF_SVM parameter optimization")
    plt.legend()
    plt.show()


