clear;
clc;
close all;
TC1 = 300; %车辆固定成本
TC2 = 1.2; %运输成本
len = 500; %车辆最大限行距离
c1 = 90 / 60; %每分钟的惩罚成本
Vk = 45;%速度
cap=3000;%车辆最大装载量
data = xlsread('坐标.xlsx');
h=pdist(data(:,2:3));
dist=squareform(h); 
transport_time = dist * 60 / Vk;

E=data(1,5);%配送中心时间窗开始时间
L=data(1,6);%配送中心时间窗结束时间
customers_demand =data(2:end,[1,4]); % 需求量
customers_time = data(2:end,5:6); % 时间窗约束
service_time = data(2:end, 7);%服务时间
customer = [customers_demand,customers_time,service_time];   %客户的基本信息
cusnum = size(customer, 1);
v_num=cusnum;   %车辆最多使用数目

NIND=100;    %种群大小
MAXGEN=500;   %迭代次数
Pc=0.9;       %交叉概率
Pm=0.01;     %变异概率
N=cusnum+v_num-1; %染色体长度=顾客数目+车辆最多使用数目-1
fitness = zeros(MAXGEN, 1);
%% 初始化种群
Chrom=InitPopCW(NIND,N,cusnum,customers_time,customers_demand,cap,len,dist);

%% 计算目标函数值
ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len);

%% 
Generation=1;
while Generation <= MAXGEN
    %% 选择
    SelCh = Select(Chrom,ObjV);
    %% OX交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 局部搜索操作
    SelCh=LocalSearch(SelCh,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len);
    %% 删除种群中重复个体，并补齐删除的个体
    SelCh=deal_Repeat(SelCh);
    %% 筛选出新一代子代
    Chrom = [Chrom;SelCh];
    ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len);
    [ObjV1,idx]=sort(ObjV);
    Chrom = Chrom(idx,:);
    Chrom = Chrom(1:NIND,:);
    fprintf('第%d次迭代\n',Generation);
    fitness(Generation) = ObjV1(1);
    ObjV = ObjV1(1:NIND);
    Generation = Generation+1;
end
figure(1)
plot(1:MAXGEN, fitness);
ylabel('成本');
xlabel('迭代次数');
title('迭代过程');

demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
saveas(gcf,'迭代过程图.png');
[VC,NV,~,violate_num,~]=decode(Chrom(1,:),cusnum,cap,demands,a,b,L,s,dist,len);
fprintf('总成本为：%.2f,共使用了%d辆车\n',ObjV(1),NV);
draw_Best(VC,data(:,2:3));
