clear;clc;close all;
%% 模型参数设置
LT2=3;
C5=200;
Y1=4;
DS=2;
LT1=LT2*DS;
T=30;
C6=0.2;
P2=22;
flag=input('请输入flag（flag=1表示计算r<LT1;flag=0表示计算r>=LT1)：'); % 设置求解标记，flag=1表示计算r<LT1;flag=0表示计算r>=LT1;

%% 遗传参数设置
NUMPOP=50;%初始种群大小
if flag
    % r<LT1
    % 判断LT1是否为小数
    if floor(LT1)==LT1
        r_min=1; %问题解区间
        r_max=floor(LT1)-1;
    else
        r_min=1; %问题解区间
        r_max=floor(LT1);
    end
else
    % r>=LT1
    r_min=ceil(LT1); %问题解区间
    r_max=3*ceil(LT1);%为了计算方便，也给r设定一个上限
end
q_min=1;
q_max=100;
%对于一个变量x，取值范围为[a,b]，精度为e，则转化为二进制编码所需的最大染色体长度计算公式为log2((b-a)/e  + 1)
r_l = ceil(log2(r_max-r_min+1)); %变量r所需的染色体长度
q_l = ceil(log2(q_max-q_min+1));
LENGTH=[r_l,q_l]; %二进制编码长度
ITERATION = 500;%迭代次数
CROSSOVERRATE = 0.9;%杂交率
SELECTRATE = 0.5;%选择率
VARIATIONRATE = 0.05;%变异率

%% 初始化种群
pop=m_InitPop(NUMPOP,r_min,r_max,q_min,q_max);

%% 开始迭代
for time=1:ITERATION
    if flag
        fprintf('==========迭代次数：%d(r<LT1)=========\n',time);
    else
        fprintf('==========迭代次数：%d(r>=LT1)=========\n',time);
    end
    %计算初始种群的适应度
    fitness=m_Fitness(pop,LT1,C5,Y1,DS,T,C6,P2);
    %选择
    pop=m_Select(fitness,pop,SELECTRATE);
    %编码
    binpop=m_Coding(pop,LENGTH,r_min,r_max,q_min,q_max);
    %交叉
    kidsPop = crossover(binpop,NUMPOP,CROSSOVERRATE,LENGTH);
    %变异
    kidsPop = Variation(kidsPop,VARIATIONRATE,LENGTH);
    %解码
    kidsPop=m_Incoding(kidsPop,r_min,r_max,q_min,q_max,LENGTH);
    %更新种群
    pop=[pop kidsPop];
    fitness=m_Fitness(pop,LT1,C5,Y1,DS,T,C6,P2);
    [f,idx]=min(fitness);
    fprintf('订货点=%d；',pop(1,idx));
    fprintf('订货量=%d；',pop(2,idx));
    fprintf('总库存费用=%.2f\n',f);
    iter_fit(time)=f;
end

figure
hold on
box on
title('迭代变化曲线');
plot(iter_fit);
xlabel('迭代次数');
ylabel('总库存费用');
hold off
    


