clc;
clear;
close all;

%% 模型参数设置
a = 0.05; % 容差范围
R1 = 1;
R3 = 1;
R4 = 1;
R5 = 1;
R6 = 1;
C1 = 0.1;
C2 = 0.1;%单位0.1uF
R2_min = 1 * 10^(-4);
R2_max = 10; % 10千欧为单位
M = 0.9484 - 0.8283i;
f = 1; % 频率为1KHZ
minRealVal=[R1*(1-a),R2_min,R3*(1-a),R4*(1-a),R5*(1-a),R6*(1-a),C1*(1-a),C2*(1-a)];%各个参数的最小值
maxRealVal=[R1*(1+a),R2_max,R3*(1+a),R4*(1+a),R5*(1+a),R6*(1+a),C1*(1+a),C2*(1+a)];%各个参数的最大值

%% 遗传参数设置
N = 100; % 种群数目
G = 500; % 迭代次数
gen_len = 8; % 染色体长度
cross_n = 1; % 模拟交叉算子的分布因子
mutation_rate = 0.1; % 变异率
N_m = 4;   % 多项式变异中的分布指数

%% 初始化种群
pop = initPoP(N,gen_len,R1,R2_min,R2_max,R3,R4,R5,R6,C1,C2,a);

%% 计算适应度
fitness = cal_fitness( pop,f,M);

%% 算法迭代
iter=1;
record_fit=zeros(G,1);
while iter <= G
    % 模拟二进制交叉算子
    new_pop = crossover( pop,cross_n );
    % 多项式变异
    new_pop = mutation (new_pop,minRealVal,maxRealVal,mutation_rate,N_m);
    % 计算子代的适应度
    new_fitness = cal_fitness( new_pop,f,M);
    % 合并种群
    all_pop = [pop;new_pop];
    all_fit = [fitness;new_fitness];
    % 计算适应度小于0.01*abs(M)的个数
    D = sum(all_fit<=0.01*abs(M));
    % 选择子代
    pop=select(all_pop,all_fit,N,D,M);
    fitness=cal_fitness( pop,f,M);
    record_fit(iter)=min(fitness);
    iter = iter + 1;
end
%绘制散点图，里面的2表示故障是R2
scatter(pop(fitness<0.01*abs(M),2),fitness(fitness<0.01*abs(M)))
xlabel('fault parameter(单位10KΩ)')
ylabel('g')
ub_lb = pop(fitness<=0.001,:);
fprintf('故障上限为：%.2fKΩ,故障下限为：%.2fKΩ\n',max(ub_lb(:,2))*10,min(ub_lb(:,2))*10);












