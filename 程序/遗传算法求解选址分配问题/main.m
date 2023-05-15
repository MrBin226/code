clc;
clear;
close all;

%% 模型参数设置
lb = [50 * 10000, 40 * 10000, 30 * 10000]; %第l级物资储备库下界
ub = [100 * 10000, 70 * 10000, 40 * 10000]; %第l级物资储备库上界
C = 3; %覆盖等级
S = 500; %总场景数
L = 3; %储备库等级
pur = 10 * 10000;%应急物资单位采购成本（元/万公斤）
stro = 4 * 10000;%应急物资单位存储成本（元/万公斤）
h = 0.0012 * 10000;%应急物资单位距离运输成本（元/万公斤*公里）
c = [1000 * 10000, 800 * 10000, 600 * 10000];%第l级应急储备库的建设及维护成本
D = [30, 60, 120]; % c级覆盖允许的最大距离
p = [0.9, 0.8, 0.7;0.6, 0.5, 0.4;0.3, 0.2, 0.1];%需求点覆盖等级c和应急物资储备库建设等级l对应的覆盖率
rho = [0.53, 0.33, 0.14];%覆盖等级c对应的覆盖率权重
P_s = 1/S; %各场景发生的概率

distance = xlsread('数据.xlsx','距离');%候选点到各个需求点的距离
demand = xlsread('数据.xlsx','各场景需求量');%各个场景下各需求点的需求量
demand = demand * 10000;
% 得到储备库覆盖等级判断矩阵
theta=cell(1,C);
for i=1:C
    if i==1
        theta{i}=double(distance<=D(i));
    else
        theta{i}=double(distance<=D(i) & distance>D(i-1));
    end
end
% 需求点能否被候选点覆盖判断矩阵
A=double(distance<=D(end));

%% 算法参数设置
max_iter=10;%最大迭代次数
popsize=50;%种群个数
cross_rate=0.9;%交叉概率
mutate_rate=0.01;%变异概率

%% 初始化种群
pop=initPoP(popsize,A,L);

%% 适应度计算
ObjV=cal_fitness(pop,distance,demand,A,ub,lb,C,S,L,pur,stro,h,c,P_s,theta,rho,p);

Generation=1;
min_fitness=zeros(max_iter,1);
while Generation <= max_iter
    %% 选择
    SelCh = select(pop,ObjV);
    %% 交叉操作
    SelCh=crossover(SelCh,cross_rate,A,L);
    %% 变异
    SelCh=Mutate(SelCh,mutate_rate,A,L);
    %% 筛选出新一代子代
    all_pop = [pop;SelCh];
    new_ObjV=cal_fitness(SelCh,distance,demand,A,ub,lb,C,S,L,pur,stro,h,c,P_s,theta,rho,p);
    all_ObjV=[ObjV;new_ObjV];
    [~,idx]=sort(all_ObjV);
    ObjV=all_ObjV(idx(1:popsize));
    pop=all_pop(idx(1:popsize));
    min_fitness(Generation)=ObjV(1);
    fprintf('第%d次迭代\n',Generation);
    Generation = Generation+1;
end
plot(1:max_iter,min_fitness);
xlabel('迭代次数')
ylabel('适应度值')
title('优化过程')
[solution] = decode(pop{1},distance,demand,A,ub,lb);
plan=solution.deliver_plan;
select_place=find(pop{1}(1,:)==1);
bulild_class=pop{1}(2,select_place);
fprintf('方案如下：\n');
fprintf('选择建设');
for i=1:length(select_place)
    fprintf('%d级储备库%d,',bulild_class(i),select_place(i));
end
fprintf('\n');
for i=1:S
    p=plan{i};
    fprintf('场景%d下：',i);
    for j=1:size(p,1)
        fprintf('储备库%d向需求点%d配送%d  ',p(j,1),p(j,2),p(j,3));
    end
    fprintf('\n');
end





