clc;
clear;
close all;

%% 模型参数
shelve_data=importdata('data.txt');%货位坐标
shelve_num=size(shelve_data,1);%货位数量
layer=shelve_data(:,3);%货位所在层数
commodity_num=15;%商品个数
order_data=importfile('order_data.txt',',');%订单数据
warehouse=struct();%仓库相关参数
warehouse.v_c=1.5;%穿梭车的速度
warehouse.v_s=1.5;%升降机的速度
warehouse.a_c=1;%穿梭车的加速度
warehouse.a_s=1;%升降机的加速度
warehouse.l=1.5;%货位长度
warehouse.h=2;%货架的高度
warehouse.t_t=1;%穿梭车的换向时间
warehouse.t_p=1;%穿梭车的装（卸）时间
warehouse.t_sc=1;%升降机与穿梭车的交互时间

%% 算法参数
pop_size=25;%种群个数
chrome_length=commodity_num;%染色体长度
MAX_Iter=100;%最大迭代次数
Pc=0.8;%交叉概率
Pm=0.1;%变异概率

%% 初始化种群
[pop] = initPoP(pop_size,chrome_length,shelve_num);

%% 计算目标值
[fitness] = cal_fitness(pop,layer,shelve_data,warehouse,order_data);

%% 非支配排序
FrontValue = NonDominateSort(fitness,0); 
CrowdDistance = CrowdDistances(fitness,FrontValue);%计算聚集距离

%% 开始迭代
Generation=1;
while Generation <= MAX_Iter
    %% 选择
    SelCh = Mating(pop,FrontValue,CrowdDistance); %交配池选择。2的锦标赛选择方式
    %% OX交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 删除种群中重复个体，并补齐删除的个体
    SelCh=deal_Repeat(SelCh,shelve_num);
    %% 筛选出新一代子代
    pop = [pop;SelCh];
    [fitness] = cal_fitness(pop,layer,shelve_data,warehouse,order_data);
    [FrontValue,MaxFront] = NonDominateSort(fitness,0); 
    CrowdDistance = CrowdDistances(fitness,FrontValue);%计算聚集距离
    
    %选出非支配的个体        
    Next = zeros(1,pop_size);
    N_con = 0;
    t=1;
    for k=1:MaxFront
        if (N_con + length(find(FrontValue==k)))<=pop_size
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
        Next(t:pop_size) = Last(Rank(1:pop_size-t+1));
    end
     %下一代种群
    pop = pop(Next,:);
    FrontValue = FrontValue(Next);
    CrowdDistance = CrowdDistance(Next);

    [fitness] = cal_fitness(pop,layer,shelve_data,warehouse,order_data);
    fprintf('第%d次迭代\n',Generation);
    Generation = Generation+1;
end
fid = fopen('result.txt','w');
n_o = find(FrontValue==1);
disp('帕累托解如下：');
for i=1:length(n_o)
    fprintf(fid,'第%d个解，目标值1为：%.2f，目标值2为：%.2f\n',i,fitness(n_o(i),1),fitness(n_o(i),2));
    for j=1:chrome_length
        fprintf(fid,'%d->(%d,%d,%d)\n ',j,shelve_data(pop(n_o(i),j),1),shelve_data(pop(n_o(i),j),2),shelve_data(pop(n_o(i),j),3));
    end
end
fclose(fid);
figure(1)
scatter(fitness(n_o,1),fitness(n_o,2),'filled');
ylabel('穿梭车工作量平衡');
xlabel('工作时间');
title('帕累托最优解');







