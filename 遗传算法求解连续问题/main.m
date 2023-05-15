clc;
clear;
tic
%% 问题参数设置
w_len=9;%W矩阵的全部元素个数
%用于初始化
w =[0.0922193973630614,-0.00110595318277262,0.0234449494988418;0.0471691430333492,0.0579241010335920,0.00133658921661350;-0.00575899047346251,-0.00449380033575153,0.148292539942199];
% 将w变为行向量
w=reshape(w,1,w_len);
w_max=0.15;%W的最大值
w_min=-0.15;%W的最小值
minRealVal=ones(1,w_len)*w_max;
maxRealVal=ones(1,w_len)*w_min;
[rgb,xyz]=produce_data();%得到RGB值，和XYZ值
wlength = [400 10 700];
lsource = 'D65';   
system = 1964;
if (system == 1964)
    load xyz1964.dat; st = xyz1964;
else
    load xyz1931.dat; st = xyz1931;
end
load lsources.dat;

%% 遗传算法参数设置
max_iter=1000;%最大迭代次数
popsize=100;%种群个数
select_rate=0.9;%选择概率
crossover_rate=0.9;%交叉概率
mutate_rate=0.1;%变异概率
cross_n = 1; % 模拟交叉算子的分布因子
N_m = 10;   % 多项式变异中的分布指数
min_fitness=zeros(max_iter,1);

%% 初始化种群
pop = initPop(popsize,w,w_len);

%% 适应度函数计算
fitness = cal_fitness(pop,wlength,lsource,system,rgb,xyz,lsources,st);
[~,idx]=min(fitness);
best_pop=pop(idx,:);

%% 开始迭代
for iter=1:max_iter
    %% 二元锦标选择策略
    new_pop = select(pop,fitness,select_rate);
    %% 模拟交叉
    new_pop = crossover(new_pop,crossover_rate,wlength,lsource,system,rgb,xyz,lsources,st);
    %% 多项式变异
    if iter > max_iter/4 && iter < max_iter/2
        new_pop = mutation(new_pop,best_pop,new_pop(1,:),mutate_rate);
    end
    if iter <=max_iter/4 || iter >= max_iter/2
        new_pop = mutation1(new_pop,minRealVal,maxRealVal,mutate_rate,N_m);
    end
    %% 将变异后的个体与种群组合在一起，选出适应度更优的个体作为子代
    new_fit = cal_fitness(new_pop,wlength,lsource,system,rgb,xyz,lsources,st);
    
    [fitness,idx]=sort(fitness);
    fitness = [fitness(1:popsize-popsize*select_rate);new_fit];
    pop=[pop(idx(1:popsize-popsize*select_rate),:);new_pop];
    [fitness, idx]=sort(fitness);
    pop = pop(idx,:);
    min_fitness(iter)=fitness(1);
    fprintf('第%d次迭代，适应度值为%.2f\n',iter,fitness(1));
    crossover_rate = 0.9-0.2*(iter/max_iter);
    mutate_rate = 0.1+0.5*(iter/max_iter);
    best_pop=pop(1,:);
end
figure()
hold on
plot(1:max_iter,min_fitness)
xlabel('迭代次数')
title('优化过程')
ylabel('适应度值')
hold off
disp('最终的M：');
disp(reshape(pop(1,:),3,6))
toc










