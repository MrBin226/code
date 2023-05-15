%% 清空环境变量
clc;
clear all
close all
nntwarn off;
%% 数据载入
data=xlsread('数据(1).xlsx');
a=data;
%% 选取训练数据和测试数据
% 训练数据输入
p_train=a(1:27,1:5);
% 训练数据输出
t_train=a(1:27,6);
% 测试数据输入
p_test=a(28:30,1:5);
% 测试数据输出
t_test=a(28:30,6);

% 为适应网络结构 做转置
p_train=p_train';
t_train=t_train';
p_test=p_test';

[p_train,minp,maxp,t_train,mint,maxt]=premnmx(p_train,t_train);%数据归一化
p_test= tramnmx(p_test,minp,maxp);
%% 网络相关参数设定
hiddNum = 10;%隐含层个数
R = size(p_train,1);%输入数据每组的维度
Q = size(t_train,1);%输出数据的维度
threshold = minmax(p_train);%每组数据对应维度的最小（0）和最大值（1）;

%% MPA相关参数设定
SearchAgents_no=20; %种群数量
Max_iteration=30; %  设定最大迭代次数
dim = hiddNum*R + hiddNum + Q + hiddNum*hiddNum + Q*hiddNum;%维度，即权值与阈值的个数，承接层个数
lb = -1;%下边界
ub = 1;%上边界
fobj = @(x) fun(x,hiddNum,R,Q,threshold,p_train,t_train,p_test,t_test,mint,maxt);
[Best_score,Best_pos,Convergence_curve,net]=MPA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);%开始优化
[Best_score1,Best_pos1,Convergence_curve1,net1]=MPA1(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);%开始优化
%获取最优权值和阈值时的网络，以及对测试数据的预测误差
% 预测数据
y=sim(net,p_test);
y=postmnmx(y,mint,maxt);
% 计算误差
error = y'-t_test;
ESum = sum(abs(error));
% 预测数据
y1=sim(net1,p_test);
y1=postmnmx(y1,mint,maxt);
% 计算误差
error1 = y1'-t_test;
ESum1 = sum(abs(error1));

%% 得到MMPA-ELman和MPA-Elman的训练过程
[tr] = get_train(Best_pos,hiddNum,R,Q,threshold,p_train,t_train);
[tr1] = get_train(Best_pos1,hiddNum,R,Q,threshold,p_train,t_train);

%% 绘制测试样本的误差曲线
figure
plot(abs(error1),'ro-','linewidth',2);
hold on
plot(abs(error),'b*-','linewidth',2);
title('预测绝对误差图')
set(gca,'Xtick',[1:3])
legend('MMPA-Elman','MPA-Elman')
xlabel('测试样本')
ylabel('误差')
hold off;
grid on;
disp(['MMPA-Elman的绝对误差和：',num2str(ESum1)])
disp(['MPA-Elman的绝对误差和：',num2str(ESum)])

%% 绘制测试样本的预测曲线
figure
plot(y,'ro-','linewidth',2);
hold on
plot(y1,'bo-','linewidth',2);
plot(t_test,'blacko-','linewidth',2);
title('测试样本预测图')
set(gca,'Xtick',[1:3])
legend('MPA-Elman','MMPA-Elman','真实值')
xlabel('测试样本')
ylabel('预测值')
hold off;
grid on;


%% 绘制收敛曲线
figure
plot(Convergence_curve,'linewidth',1.0);
hold on
plot(Convergence_curve1,'r','linewidth',1.0);
legend('MPA-Elman','MMPA-Elman')
title('收敛曲线')
xlabel('迭代次数')
ylabel('适应度值')
grid on

%% 绘制MMPA-ELman和MPA-ELMan的训练过程
figure
semilogy(tr.perf,'linewidth',1);
hold on
semilogy(tr1.perf,'r','linewidth',1.0);
legend('MPA-Elman','MMPA-Elman')
title('MPA-Elman和MMPA-Elman的均方误差曲线')
xlabel('训练次数')
ylabel('均方误差')





