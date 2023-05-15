% 基于PSO-Elman神经网络的电力负荷预测模型研究
%% by Jack旭 ： https://mianbaoduo.com/o/bread/mbd-YZaTlppv
%% 清空环境变量
clc;
clear all
close all
nntwarn off;
%% 数据载入
load data;
a=data;
%% 选取训练数据和测试数据
for i=1:6
    p(i,:)=[a(i,:),a(i+1,:),a(i+2,:)];
end
% 训练数据输入
p_train=p(1:5,:);
% 训练数据输出
t_train=a(4:8,:);
% 测试数据输入
p_test=p(6,:);
% 测试数据输出
t_test=a(9,:);

% 为适应网络结构 做转置
p_train=p_train';
t_train=t_train';
p_test=p_test';


%% 网络相关参数设定
hiddNum = 18;%隐含层个数
R = size(p_train,1);%输入数据每组的维度
Q = size(t_train,1);%输出数据的维度
threshold = [0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1];%每组数据对应维度的最小（0）和最大值（1）;

%% 粒子群相关参数设定
%% 定义粒子群优化参数
pop=20; %种群数量
Max_iteration=30; %  设定最大迭代次数
dim = hiddNum*R + hiddNum + Q + hiddNum*hiddNum + Q*hiddNum;%维度，即权值与阈值的个数，承接层个数
lb = -1;%下边界
ub = 1;%上边界
Vmax = 0.5;
Vmin = -0.5;
fobj = @(x) fun(x,hiddNum,R,Q,threshold,p_train,t_train,p_test,t_test);
[Best_pos,Best_score,PSO_curve,net]=PSO(pop,Max_iteration,lb,ub,dim,fobj,Vmax,Vmin); %开始优化
%获取最优权值和阈值时的网络，以及对测试数据的预测误差
% 预测数据
y=sim(net,p_test);
% 计算误差
error = y'-t_test;
ESum = sum(abs(error));

%% 利用基础Elman进行预测
% 建立Elman神经网络 隐藏层为hiddNum个神经元
net1=newelm(threshold,[hiddNum,Q],{'tansig','purelin'});
% 设置网络训练参数
net1.trainparam.epochs=100;
net1.trainParam.showWindow = false; 
net1.trainParam.showCommandLine = false; 
 % 初始化网络
 net1=init(net1);
% Elman网络训练
net1=train(net1,p_train,t_train);
% 预测数据
y1=sim(net1,p_test);
% 计算误差
error1 = y1'-t_test;
ESum1 = sum(abs(error1));

%% 通过作图 观察不同隐藏层神经元个数时，网络的预测效果
figure
plot(abs(error),'ro-','linewidth',2);
hold on
plot(abs(error1),'b*-','linewidth',2);
title('Elman预测绝对误差图')
set(gca,'Xtick',[1:3])
legend('PSO-Elman','原始Elman')
xlabel('时间点')
ylabel('误差')
hold off;
grid on;
disp(['原始Elman的绝对误差和：',num2str(ESum1)])
disp(['PSO-Elman的绝对误差和：',num2str(ESum)])


%% 绘制粒子群收敛曲线
figure
plot(PSO_curve,'linewidth',1.5);
title('粒子群收敛曲线')
xlabel('迭代次数')
ylabel('适应度值')
grid on
