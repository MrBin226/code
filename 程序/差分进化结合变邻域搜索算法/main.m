clc;
clear;
close all;

%% 读取相关数据
% order_data=importfile('order.txt',',');%订单数据
% due_time=importfile('due.txt',',');%订单截止时间
% due_time=cell2mat(due_time);
order_data=arrayfun(@(x) randperm(100,randi([4 6])),1:30,'UniformOutput',0)';
due_time=randi([10,100],30,1);
shelve_data=reshape(1:100,5,20)';%货架上存放商品信息
shelve_data=num2cell(shelve_data,2);

%% 设置模型相关参数
order_num=size(order_data,1);%订单数量
C=6;%每个批次中的最大订单数量
E=2;%每个批次中的最小订单数量
batch_num=order_num;%最大批次数
t1=6;%移动机器人搬运一次货架的时间
t2=1;%拣货员拣选一次SKU的时间
lambda=0.3;%加权相似度参数

%% 算法相关参数设置
chromosome_length=order_num+batch_num-1;%染色体长度为订单数+最大批次数-1
NP=30;%种群数量
F=0.5;%缩放因子
CR=0.8;%交叉概率
max_iter=50;%最大迭代次数
len=floor(order_num/3);
min_fitness=zeros(max_iter,1);
best_sol=[];
best_fit=inf;

%% 计算订单的加权相似度
order_similarity=cal_order_similarity(order_data);
shelve_similarity=cal_shelve_similarity(order_data,shelve_data);
weight_similarity=lambda*order_similarity+(1-lambda)*shelve_similarity;

%% 种群初始化
[chromesome] = initPop(NP,chromosome_length,order_num,order_data,shelve_data,E,C,t1,t2,weight_similarity);

%% 计算目标函数
[fitness] = cal_fitness(chromesome,order_data,shelve_data,due_time,t1,t2,C,E);

%% 开始迭代
for iter=1:max_iter
    % 变异
    [V] = mutation(chromesome,F,order_num,batch_num,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data);
    % 交叉
    [V] = crossover(chromesome,V,CR,fitness,order_data,shelve_data,due_time,t1,t2,C,E,weight_similarity);
    % 大领域搜索
    chromesome = LargeSearch(V,len,order_num,E,C,order_data,shelve_data,due_time,t1,t2,weight_similarity);
    % 计算目标函数
    [fitness] = cal_fitness(chromesome,order_data,shelve_data,due_time,t1,t2,C,E);
    [~,idx]=min(fitness);
    if best_fit > fitness(idx)
        best_sol=chromesome(idx,:);
        best_fit=fitness(idx);
    end
    min_fitness(iter)=best_fit;
    fprintf('第%d次迭代，目标函数为：%d\n',iter,best_fit);
end

[order_batch] = decode(best_sol);
disp('分批情况如下：');
for i=1:length(order_batch)
    fprintf('第%d批订单:',i);
    temp=order_batch{i};
    for j=1:length(temp)
        fprintf('%d  ',temp(j));
    end
    fprintf('\n');
end

figure(1)
plot(1:max_iter,min_fitness);
xlabel('迭代次数');
ylabel('目标函数');
title('迭代过程')





















