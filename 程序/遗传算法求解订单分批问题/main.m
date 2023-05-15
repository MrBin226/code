clc;
clear;
close all;

%% 模型数据
data=xlsread('data.xlsx');
coordinate=data(:,2:4);%各个序号的坐标
volume=data(:,5).*data(:,6);%各个序号的体积，数量*单位体积
max_volume=20000;%周转箱最大容积
origin_coordinate=[0,0,0];%起始点终止点的坐标
a=1.5;%通道宽度
b=1;%巷道宽度
c=0.1;%每个货架宽
d=1;%库位长
cusnum=size(coordinate,1);%全部待取货物的种类数
[dist,origin_dis] = cal_distance(coordinate,origin_coordinate,a,b,c,d);%dist是两两货物之间的距离，origin_dis是起始点到每一个货物的距离

%% 遗传算法参数
alpha=10;                                                       %违反的容量约束的惩罚函数系数
NIND=50;                                                        %种群大小
MAXGEN=100;                                                     %迭代次数
Pc=0.9;                                                         %交叉概率
Pm=0.05;                                                        %变异概率
GGAP=0.9;                                                       %代沟(Generation gap)
N=cusnum+cusnum-1;                                               %染色体长度=各个订单商品数目+最多拣选路径数目-1

%% 种群初始化
Chrom=InitPop(NIND,N);
disp('初始种群中的一个随机值:')
[currVC,NV,TD,violate_num,violate_cus]=decode(Chrom(1,:),cusnum,max_volume,volume,dist,origin_dis);       %对初始解解码
disp(['拣选路径数目：',num2str(NV),'，拣选总距离：',num2str(TD)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% 优化
BestCost=zeros(MAXGEN,1);       %记录每一代全局最优解
gen=1;
while gen<=MAXGEN
    %% 计算适应度
    ObjV=calObj(Chrom,cusnum,max_volume,volume,dist,origin_dis,alpha);                           %计算种群目标函数值
    FitnV=Fitness(ObjV);
    %% 选择
    SelCh=Select(Chrom,FitnV,GGAP);
    %% OX交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 局部搜索操作
    SelCh=LocalSearch(SelCh,cusnum,max_volume,volume,dist,origin_dis,alpha);
    %% 重插入子代的新种群
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% 删除种群中重复个体，并补齐删除的个体
    Chrom=deal_Repeat(Chrom);
    %% 打印当前最优解
    ObjV=calObj(Chrom,cusnum,max_volume,volume,dist,origin_dis,alpha);                           %计算种群目标函数值
    [minObjV,minInd]=min(ObjV);
    BestCost(gen)=minObjV;
    disp(['第',num2str(gen),'代最优解:'])
    [bestVC,bestNV,bestTD,best_vionum,best_viocus]=decode(Chrom(minInd(1),:),cusnum,max_volume,volume,dist,origin_dis);
    disp(['拣选路径数目：',num2str(bestNV),'，拣选总距离：',num2str(bestTD)]);
    fprintf('\n')
    %% 更新迭代次数
    gen=gen+1 ;
end
%% 打印外层循环每次迭代的全局最优解的总成本变化趋势图
figure;
hold on
plot(BestCost,'LineWidth',1);
title('全局最优解的距离变化趋势图')
xlabel('迭代次数');
ylabel('拣选总距离');
hold off
disp('每条拣选路径的拣选顺序如下所示：')
for i=1:bestNV
    p_l= part_length(bestVC{i},dist,origin_dis);
    fprintf('拣选路径%d(距离为%.2f)：',i,p_l);
    for j=1:length(bestVC{i})
        fprintf('%d  ',bestVC{i}(j));
    end
    fprintf('\n');
end
draw_Best(bestVC,coordinate,origin_coordinate);








