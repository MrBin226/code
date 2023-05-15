clc;
clear;
close all;

%% 模型数据
data=xlsread('数据.xlsx','A1:D1002');
data1=readtable('T.txt');
xx=[data1.x data1.y];
order=data1.order;
for ii=1:size(xx,1)
disp('----------------------------------------');
fprintf('第%d类',ii);
C=xx(ii,:);%聚类中心坐标点
% 属于这一类的各个顾客编号
cum=str2num(char(split(order{ii},',')))';
demand=data(cum+1,4);%客户的需求量
vertexs=[C;data(cum+1,2:3)];%所有点的坐标x和y
vehicle_model=2;%车辆型号数
vehicle_cap=[24.1,3.8];%对应车辆的容量限制
customer=vertexs(2:end,:);%顾客坐标
cusnum=size(customer,1); %顾客数
vehicle_num=[60,20];%车辆数量
vehicle_start_cost=[120,30];%车辆启用成本
transport_cost=[1.68,0.7];%运输单位距离成本
w1=[0.25,0.41;0.13,0.32];%空载和满载单位运输距离燃油消耗的成本
w2=6.29;%油价
% w=3;%人工配送成本
h=pdist(vertexs);
dist=squareform(h);                 %距离矩阵
% h1=pdist(data(2:end,2:3));
% dist1=squareform(h1);                 %距离矩阵
% people_cost=arrayfun(@(x) w*dist1(data1.index1(x),data1.index2(x)),1:length(demand));
% people_cost=sum(people_cost);

%% 遗传算法参数设置
popsize=50;                                                    %种群大小
MAXGEN=500;                                                     %迭代次数
Pc=0.9;                                                        %交叉概率
Pm=0.05;                                                       %变异概率

%% 初始化种群
[pop_x,pop_y]=initPoP(popsize,cusnum,vehicle_num,vehicle_model);

%% 计算适应度
fitness=cal_fitness(pop_x,pop_y,demand,dist,vehicle_cap,vehicle_start_cost,transport_cost,w1,w2);

min_fitness=zeros(MAXGEN,1);

%% 开始迭代
for iter=1:MAXGEN
    %% 选择(二元锦标选择策略)
    [new_pop_x,new_pop_y]=select(pop_x,pop_y,fitness);
    %% 交叉(new_pop_x采用ox交叉策略，new_pop_y采用单点交叉)
    [new_pop_x,new_pop_y]=crossover(new_pop_x,new_pop_y,Pc,demand,vehicle_cap);
    [new_pop_y] = adjustPoP(new_pop_x,new_pop_y,vehicle_model,vehicle_num,demand,vehicle_cap);
    %% 变异(new_pop_x采用反转突变，new_pop_y采用单点变异)
    [new_pop_x,new_pop_y]=Mutate(new_pop_x,new_pop_y,Pm,demand,vehicle_cap,vehicle_model);
    [new_pop_y] = adjustPoP(new_pop_x,new_pop_y,vehicle_model,vehicle_num,demand,vehicle_cap);
    %% 产生新的子代
    new_fit=cal_fitness(new_pop_x,new_pop_y,demand,dist,vehicle_cap,vehicle_start_cost,transport_cost,w1,w2);
    all_pop_x=[pop_x;new_pop_x];
    all_pop_y=[pop_y;new_pop_y];
    all_fit=[fitness;new_fit];
    [~,idx]=sort(all_fit);
    pop_x=all_pop_x(idx(1:popsize),:);
    pop_y=all_pop_y(idx(1:popsize),:);
    [~,k] = unique(pop_x,'rows','stable');
    pop_x=pop_x(k,:);
    pop_y=pop_y(k,:);
    if size(pop_x,1)<popsize
        [rand_pop_x,rand_pop_y]=initPoP(length(setdiff(1:popsize,k)),cusnum,vehicle_num,vehicle_model);
        pop_x=[pop_x;rand_pop_x];
        pop_y=[pop_y;rand_pop_y];
    end
    fitness=cal_fitness(pop_x,pop_y,demand,dist,vehicle_cap,vehicle_start_cost,transport_cost,w1,w2);
    min_fitness(iter)=min(fitness);
%     fprintf('第%d次迭代\n',iter);
end
% figure(ii)
% plot(min_fitness,'LineWidth',1);
% title('全局最优解的距离变化趋势图')
% xlabel('迭代次数');
% ylabel('总成本');

[minCost,minInd]=min(fitness);
fprintf('最终总成本为：%.2f\n',minCost);
[VC,num,vc_model]=decode(pop_x(minInd,:),pop_y(minInd,:),demand,vehicle_cap);
disp('行驶方案如下：')
for i=1:num
    fprintf('第%d辆车（型号为%d）：',i,vc_model(i));
    r=VC{i};
    for j=1:length(r)
        fprintf('%d  ',cum(r(j)));
    end
    fprintf('\n');
end
end













