clc;
clear;
close all;
%% 模型参数设置
data=xlsread('data.xls');
a = unique(data(:,1:2),'rows','stable');
b = arrayfun(@(x) sum(data(data(:,1:2) == a(x),3)),1:length(a));
data = [(1:length(a))',a,b'];
c = arrayfun(@(x) randi(b(x)+2)-1,1:length(b));
data=[data,c'];
h=pdist(data(:,2:3));
dist=squareform(h);%各个站点间的距离
num=size(data,1);%站点个数

%% 算法参数设置
q=0.5;%冷却系数
T0=100;%初始温度
Tf=2;%终止温度
T=T0;%当前温度
Markov_length=100;%马尔可夫链的长度
popsize=25;%种群大小
crossover_rate=0.9;%交叉概率
mutate_rate=0.2;%变异概率

%% 初始化种群
[pop,car_now] = initPop(popsize,num,data);

%% 计算适应度函数
fitness = cal_fitness(pop,data,dist,car_now);
[E_best,idx]=min(fitness);
sol_best=pop(idx,:);
min_fitness=[];
iter=1;
%% 开始迭代
while Tf<=T
    [pop,car_now] = initPop(popsize,num,data);
    fitness = cal_fitness(pop,data,dist,car_now);
    for i=1:Markov_length
        %选择:二元锦标选择
        [new_pop,select_idx]=select(pop,fitness);
        %交叉
        new_pop=crossover(new_pop,crossover_rate);
        %变异
        new_pop=mutation(new_pop,mutate_rate,data,dist);
        cars_now=cal_final_cars(new_pop,data);
        new_fit=cal_fitness(new_pop,data,dist,car_now);
        for k=1:popsize
            if new_fit(k)<=fitness(select_idx(k))
                pop(select_idx(k),:)=new_pop(k,:);
                fitness(select_idx(k))=new_fit(k);
                if new_fit(k)<E_best
                    E_best=new_fit(k);
                    sol_best=new_pop(k,:);
                end
            else
                 if rand() < exp(-(new_fit(k)-fitness(select_idx(k)))/T)
                     pop(select_idx(k),:)=new_pop(k,:);
                     fitness(select_idx(k))=new_fit(k);
                 end
            end
        end
    end
    T=0.99*T;
    min_fitness=[min_fitness E_best];
    fprintf('第%d次迭代，最优适应度值为%.4f\n',iter,E_best);
    iter=iter+1;
end
figure()
hold on
plot(1:length(min_fitness),min_fitness)
xlabel('迭代次数')
ylabel('适应度值')
title('迭代过程')
hold off
disp('最优方案为：')
for i=1:num
    if sol_best{i}~=[0;0]
        a=sol_best{i};
        for k=1:size(a,2)
            fprintf('站点%d往站点%d调度汽车%d辆\n',i,a(1,k),a(2,k));
        end
    end
end

























