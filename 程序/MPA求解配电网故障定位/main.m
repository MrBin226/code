clear all
clc
format long
%% ��ز���
% ������Ľṹ��net_struct{i,1}=[1��2��3��...��j]��ʾ�����i�����η������ϣ���1��j���Ĳ�ص�״̬Ϊ1
net_struct{1,1}=[1];net_struct{2,1}=[1,2];net_struct{3,1}=[1,2,3];
net_struct{4,1}=[1,2,3,4];net_struct{5,1}=[1,2,3,4,5];
net_struct{6,1}=[1,2,3,4,5,6];net_struct{7,1}=[1,2,3,4,5,6,7];
net_struct{8,1}=[1,2,3,4,5,6,7,8];net_struct{9,1}=[1,2,3,4,9];
net_struct{10,1}=[1,2,3,4,9,10];net_struct{11,1}=[1,2,3,4,9,10,11];
net_struct{12,1}=[1,2,3,4,9,10,11,12];net_struct{13,1}=[1,2,3,4,9,13];
net_struct{14,1}=[1,2,14];net_struct{15,1}=[1,2,14,15];net_struct{16,1}=[1,2,14,15,16];
net_struct{17,1}=[1,2,14,15,16,17];net_struct{18,1}=[1,2,14,15,16,18];net_struct{19,1}=[1,2,14,19];
net_struct{20,1}=[1,2,14,19,20];
% �ɼ����ĸ���ص㣨 FTU �� RTU����ʵ��״̬
I=[1 1 1 1 1 1 1 0 1 1 1 0 0 1 1 0 0 0 0 0];
% ��Ӧ�Ⱥ�����Ȩϵ��
w=0.5;
% ���θ���
n=20;

%% MPA�㷨��������
SearchAgents_no=25; % ��Ⱥ��С
Max_iteration=200; % ��������
lb=0;
ub=1;
fobj=@cal_fault;

[Best_score,Best_pos,Convergence_curve]=MPA(SearchAgents_no,Max_iteration,lb,ub,n,fobj,I,w,net_struct);

figure(1)
plot(1:Max_iteration,Convergence_curve);
xlabel('��������')
ylabel('��Ӧ��ֵ');

disp('������£�')
disp(Convert2binary(Best_pos));
display(['������Ӧ��Ϊ: ', num2str(Best_score,10)]);
fprintf('--------------------------------------\n');
