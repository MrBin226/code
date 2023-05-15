clear;
clc;
close all;
C1k = 0.5;
C2k = 50;
a1 = 0.1;
a2 = 0.5;
a3 = 0.2;
Vk = 50;
cap=300;%车辆最大装载量
data = xlsread('5-第二类-新.xlsx');
% data = xlsread('数据.xlsx');
h=pdist(data(:,2:3));
dist=squareform(h); 
transport_time = dist / Vk;

E=data(1,5);%配送中心时间窗开始时间
L=data(1,6);%配送中心时间窗结束时间
customers_demand =data(2:end,[1,4]); % 需求量
customers_time = data(2:end,5:6); % 时间窗约束
service_time = data(2:end, 7);%服务时间
customer = [customers_demand,customers_time,service_time];   %客户的基本信息
cusnum = size(customer, 1);
v_num=cusnum;   %车辆最多使用数目

NIND=50;    %种群大小
MAXGEN=100;   %迭代次数
Pc=0.9;       %交叉概率
Pm=0.05;     %变异概率
N=cusnum+v_num-1; %染色体长度=顾客数目+车辆最多使用数目-1
%% 初始化种群
Chrom=InitPopCW(NIND,N,cusnum,customers_time,customers_demand,cap);

%% 计算目标函数值
ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);

%% 非支配排序
FrontValue = NonDominateSort(ObjV,0); 
CrowdDistance = CrowdDistances(ObjV,FrontValue);%计算聚集距离
%% 
Generation=1;
while Generation <= MAXGEN
    %% 选择
    SelCh = Mating(Chrom,FrontValue,CrowdDistance); %交配池选择。2的锦标赛选择方式
    %% OX交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 局部搜索操作
    SelCh=LocalSearch(SelCh,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);
    %% 删除种群中重复个体，并补齐删除的个体
    SelCh=deal_Repeat(SelCh);
    %% 筛选出新一代子代
    Chrom = [Chrom;SelCh];
    ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);
    [FrontValue,MaxFront] = NonDominateSort(ObjV,0); 
    CrowdDistance = CrowdDistances(ObjV,FrontValue);%计算聚集距离
    
    %选出非支配的个体        
    Next = zeros(1,NIND);
    N_con = 0;
    t=1;
    for k=1:MaxFront
        if (N_con + length(find(FrontValue==k)))<=NIND
            N_con = N_con+length(find(FrontValue==k));
            Next(t:N_con) = find(FrontValue==k);
            t = N_con+1;
        else
            break;
        end
    end
    if ismember(0,Next)
        Last = find(FrontValue==k);
        [~,Rank] = sort(CrowdDistance(Last),'descend');
        Next(t:NIND) = Last(Rank(1:NIND-t+1));
    end
     %下一代种群
    Chrom = Chrom(Next,:);
    FrontValue = FrontValue(Next);
    CrowdDistance = CrowdDistance(Next);

    ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);
    fprintf('第%d次迭代\n',Generation);
    Generation = Generation+1;
end
figure(1)
scatter(ObjV(:,2),ObjV(:,1),'filled');
ylabel('成本');
xlabel('顾客满意度');
title('帕累托最优解');
n_o = find(FrontValue==1);
demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
[c1,c2] = sortrows(ObjV);
fprintf('成本：%f,满意度：%f\n',c1(1,1),c1(1,2));
[VC,NV,~,violate_num,~]=decode(Chrom(c2(1),:),cusnum,cap,demands,a,b,L,s,dist);
draw_Best(VC,data(:,2:3));
