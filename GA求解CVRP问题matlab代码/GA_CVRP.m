tic
clear
clc
%% 用importdata这个函数来读取文件 
data=importdata('rc208.txt');
cap=1000;
%% 提取数据信息
vertexs=data(:,2:3);                %所有点的坐标x和y
customer=vertexs(2:end,:);          %顾客坐标
cusnum=size(customer,1);            %顾客数
v_num=25;                           %初始车辆使用数目
demands=data(2:end,4);              %需求量
h=pdist(vertexs);
dist=squareform(h);                 %距离矩阵
%% 遗传算法参数设置
alpha=10;                                                       %违反的容量约束的惩罚函数系数
NIND=50;                                                        %种群大小
MAXGEN=30;                                                     %迭代次数
Pc=0.9;                                                         %交叉概率
Pm=0.05;                                                        %变异概率
GGAP=0.9;                                                       %代沟(Generation gap)
N=cusnum+v_num-1;                                               %染色体长度=顾客数目+车辆最多使用数目-1
%% 种群初始化
Chrom=InitPop(NIND,N);
%% 输出随机解的路线和总距离
disp('初始种群中的一个随机值:')
[currVC,NV,TD,violate_num,violate_cus]=decode(Chrom(1,:),cusnum,cap,demands,dist);       %对初始解解码
currCost=costFuction(currVC,dist,demands,cap,alpha);        %求初始配送方案的成本=车辆行驶总成本+alpha*违反的容量约束之和
disp(['车辆使用数目：',num2str(NV),'，车辆行驶总距离：',num2str(TD),'，违反约束路径数目：',num2str(violate_num),'，违反约束顾客数目：',num2str(violate_cus)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% 优化
BestCost=zeros(MAXGEN,1);       %记录每一代全局最优解的总成本
gen=1;
while gen<=MAXGEN
    %% 计算适应度
    ObjV=calObj(Chrom,cusnum,cap,demands,dist,alpha);                           %计算种群目标函数值
    FitnV=Fitness(ObjV);
    %% 选择
    SelCh=Select(Chrom,FitnV,GGAP);
    %% OX交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 局部搜索操作
    SelCh=LocalSearch(SelCh,cusnum,cap,demands,dist,alpha);
    %% 重插入子代的新种群
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% 删除种群中重复个体，并补齐删除的个体
    Chrom=deal_Repeat(Chrom);
    %% 打印当前最优解
    ObjV=calObj(Chrom,cusnum,cap,demands,dist,alpha);                           %计算种群目标函数值
    [minObjV,minInd]=min(ObjV);
    BestCost(gen)=minObjV;
    disp(['第',num2str(gen),'代最优解:'])
    [bestVC,bestNV,bestTD,best_vionum,best_viocus]=decode(Chrom(minInd(1),:),cusnum,cap,demands,dist);
    disp(['车辆使用数目：',num2str(bestNV),'，车辆行驶总距离：',num2str(bestTD),'，违反约束路径数目：',num2str(best_vionum),'，违反约束顾客数目：',num2str(best_viocus)]);
    fprintf('\n')
    %% 更新迭代次数
    gen=gen+1 ;
end
%% 打印外层循环每次迭代的全局最优解的总成本变化趋势图
figure;
plot(BestCost,'LineWidth',1);
title('全局最优解的总成本变化趋势图')
xlabel('迭代次数');
ylabel('总成本');
%% 打印全局最优解路线图
draw_Best(bestVC,vertexs);
toc