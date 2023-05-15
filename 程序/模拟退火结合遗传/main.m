clc;
clear;
close all;
%% 模型参数设置
ub=[12.5,80,33,2.7];%决策变量上界
lb=[8.5,70,25,2.1];%决策变量下界
varible_num=4;%变量个数
fismat=readfis('qingjiedu.fis');%读取fis文件

%% 算法参数设置
q=0.5;%冷却系数
T0=100;%初始温度
Tf=2;%终止温度
T=T0;%当前温度
Markov_length=50;%马尔可夫链的长度
popsize=25;%种群大小
mutate_rate=0.1;%变异概率
crossover_rate=0.9;
N_m = 10;   % 多项式变异中的分布指数
sol_best=arrayfun(@(x) rand().*(ub(x)-lb(x))+lb(x),1:varible_num);%全局最优个体
E_best = cal_fitness(sol_best,fismat);
min_fitness=[];
iter=1;
%% 开始迭代
while Tf<=T
    %% 初始化种群
    pop = initPop(popsize,varible_num,ub,lb);
    %% 适应度计算
    fitness = cal_fitness(pop,fismat);
    %% 遗传寻优
    for i=1:Markov_length
        %选择:二元锦标选择
        [new_pop,select_idx]=select(pop,fitness);
        %模拟二进制交叉
%         new_pop=crossover(new_pop,cross_n );
        [new_pop] = crossover1(new_pop,crossover_rate,fismat,ub,lb);
        %多项式变异
        new_pop=mutation (new_pop,lb,ub,mutate_rate,N_m);
        new_fit=cal_fitness(new_pop,fismat);
        for k=1:popsize
            if new_fit(k)>=fitness(select_idx(k))
                pop(select_idx(k),:)=new_pop(k,:);
                fitness(select_idx(k))=new_fit(k);
                if new_fit(k)>E_best
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
    T=q*T;
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
disp(sol_best);
disp('C:');
disp(evalfis(sol_best(1,:),fismat));
disp('0.011304*l*t:');
disp(0.011304*sol_best(1,3)*sol_best(1,4));
disp('0.0009324*l^2*sin(deg2rad(a)):');
disp(0.0009324*sol_best(1,3)^2*sin(deg2rad(sol_best(1,2))));
disp('0.37*t:');
disp(0.37*sol_best(1,4));

























