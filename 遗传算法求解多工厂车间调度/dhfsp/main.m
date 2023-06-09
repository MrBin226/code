clc;
clear;
close all;

%% 模型参数设置
F=3;%工厂数
c=5;%工序数
m_k={[1,3,2,2,1],[2,1,2,3,2],[2,1,2,3,3]};%各个工厂第k阶段的机器数量
n=18;%工件数
% p_ijk={[];[];[]};%各个工件在各个工厂对应各个工序的加工时间
p_ijk=cell(1,F);
for i=1:F
    p_ij=importdata(['工厂',num2str(i),'.txt']);
    p_ijk{i}=p_ij.data;
end

%% 遗传算法参数设置
popsize=10;%种群个数
max_iter=100;%最大迭代次数
cross_rate=0.7;%交叉概率
mutate_rate=0.05;%变异概率
min_fitness=zeros(max_iter,1);

%% 初始化种群
pop=initPoP(popsize,F,n);

%% 适应度计算
fitness=cal_fitness(pop,c,m_k,p_ijk);

%% 迭代过程
for iter=1:max_iter
    %% 轮盘赌选择
    new_pop=select(pop,fitness);
    %% 交叉
    new_pop=crossover(new_pop,cross_rate,n);
    %% 变异
    new_pop=mution(new_pop,mutate_rate);
    %% 筛选出子代
    new_fit=cal_fitness(new_pop,c,m_k,p_ijk);
    all_pop=[pop;new_pop];
    all_fit=[fitness;new_fit];
    [x,idx]=sort(all_fit,'descend');
    pop=all_pop(idx(1:popsize),:);
    fitness=all_fit(idx(1:popsize));
    min_fitness(iter)=fitness(1);
end
figure(1)
plot(1:max_iter,min_fitness);
xlabel('迭代次数')
ylabel('适应度值')
title('进化过程')
fprintf('最大完成时间为：%.2f\n',1/fitness(1));
for i=1:F
    [scheme,time]=decode(pop{1,i},c,m_k{i},p_ijk{i});
    fprintf('第%d个工厂所分配的零件(该工厂最大完成时间为：%.2f):',i,time);
    disp(pop{1,i});
    draw(pop{1,i},scheme,m_k{i},time,p_ijk{i},i);
end








