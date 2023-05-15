clear all
clc
format long
%% 相关参数
% 配电网的结构，net_struct{i,1}=[1，2，3，...，j]表示如果第i个区段发生故障，则1到j处的测控点状态为1
net_struct{1,1}=[1];net_struct{2,1}=[1,2];net_struct{3,1}=[1,2,3];
net_struct{4,1}=[1,2,3,4];net_struct{5,1}=[1,2,3,4,5];
net_struct{6,1}=[1,2,3,4,5,6];net_struct{7,1}=[1,2,3,4,5,6,7];
net_struct{8,1}=[1,2,3,4,5,6,7,8];net_struct{9,1}=[1,2,3,4,9];
net_struct{10,1}=[1,2,3,4,9,10];net_struct{11,1}=[1,2,3,4,9,10,11];
net_struct{12,1}=[1,2,3,4,9,10,11,12];net_struct{13,1}=[1,2,3,4,9,13];
net_struct{14,1}=[1,2,14];net_struct{15,1}=[1,2,14,15];net_struct{16,1}=[1,2,14,15,16];
net_struct{17,1}=[1,2,14,15,16,17];net_struct{18,1}=[1,2,14,15,16,18];net_struct{19,1}=[1,2,14,19];
net_struct{20,1}=[1,2,14,19,20];
% 采集到的各测控点（ FTU 或 RTU）的实际状态
I=[1 1 1 1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 0 0];
% 适应度函数的权系数
w=0.5;
% 区段个数
n=20;

%% MPA算法参数设置
SearchAgents_no=25; % 种群大小
Max_iteration=200; % 迭代次数
lb=0;
ub=1;
fobj=@cal_fault;

[Best_score,Best_pos,Convergence_curve]=MPA(SearchAgents_no,Max_iteration,lb,ub,n,fobj,I,w,net_struct);

figure(1)
plot(1:Max_iteration,Convergence_curve);
xlabel('迭代次数')
ylabel('适应度值');

disp('结果如下：')
disp(Convert2binary(Best_pos));
display(['最优适应度为: ', num2str(Best_score,10)]);
fprintf('--------------------------------------\n');
