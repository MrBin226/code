%% ��ջ�������
clc;
clear all
close all
nntwarn off;
%% ��������
data=xlsread('����(1).xlsx');
a=data;
%% ѡȡѵ�����ݺͲ�������
% ѵ����������
p_train=a(1:27,1:5);
% ѵ���������
t_train=a(1:27,6);
% ������������
p_test=a(28:30,1:5);
% �����������
t_test=a(28:30,6);

% Ϊ��Ӧ����ṹ ��ת��
p_train=p_train';
t_train=t_train';
p_test=p_test';

[p_train,minp,maxp,t_train,mint,maxt]=premnmx(p_train,t_train);%���ݹ�һ��
p_test= tramnmx(p_test,minp,maxp);
%% ������ز����趨
hiddNum = 10;%���������
R = size(p_train,1);%��������ÿ���ά��
Q = size(t_train,1);%������ݵ�ά��
threshold = minmax(p_train);%ÿ�����ݶ�Ӧά�ȵ���С��0�������ֵ��1��;

%% MPA��ز����趨
SearchAgents_no=20; %��Ⱥ����
Max_iteration=30; %  �趨����������
dim = hiddNum*R + hiddNum + Q + hiddNum*hiddNum + Q*hiddNum;%ά�ȣ���Ȩֵ����ֵ�ĸ������нӲ����
lb = -1;%�±߽�
ub = 1;%�ϱ߽�
fobj = @(x) fun(x,hiddNum,R,Q,threshold,p_train,t_train,p_test,t_test,mint,maxt);
[Best_score,Best_pos,Convergence_curve,net]=MPA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);%��ʼ�Ż�
[Best_score1,Best_pos1,Convergence_curve1,net1]=MPA1(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);%��ʼ�Ż�
%��ȡ����Ȩֵ����ֵʱ�����磬�Լ��Բ������ݵ�Ԥ�����
% Ԥ������
y=sim(net,p_test);
y=postmnmx(y,mint,maxt);
% �������
error = y'-t_test;
ESum = sum(abs(error));
% Ԥ������
y1=sim(net1,p_test);
y1=postmnmx(y1,mint,maxt);
% �������
error1 = y1'-t_test;
ESum1 = sum(abs(error1));

%% �õ�MMPA-ELman��MPA-Elman��ѵ������
[tr] = get_train(Best_pos,hiddNum,R,Q,threshold,p_train,t_train);
[tr1] = get_train(Best_pos1,hiddNum,R,Q,threshold,p_train,t_train);

%% ���Ʋ����������������
figure
plot(abs(error1),'ro-','linewidth',2);
hold on
plot(abs(error),'b*-','linewidth',2);
title('Ԥ��������ͼ')
set(gca,'Xtick',[1:3])
legend('MMPA-Elman','MPA-Elman')
xlabel('��������')
ylabel('���')
hold off;
grid on;
disp(['MMPA-Elman�ľ������ͣ�',num2str(ESum1)])
disp(['MPA-Elman�ľ������ͣ�',num2str(ESum)])

%% ���Ʋ���������Ԥ������
figure
plot(y,'ro-','linewidth',2);
hold on
plot(y1,'bo-','linewidth',2);
plot(t_test,'blacko-','linewidth',2);
title('��������Ԥ��ͼ')
set(gca,'Xtick',[1:3])
legend('MPA-Elman','MMPA-Elman','��ʵֵ')
xlabel('��������')
ylabel('Ԥ��ֵ')
hold off;
grid on;


%% ������������
figure
plot(Convergence_curve,'linewidth',1.0);
hold on
plot(Convergence_curve1,'r','linewidth',1.0);
legend('MPA-Elman','MMPA-Elman')
title('��������')
xlabel('��������')
ylabel('��Ӧ��ֵ')
grid on

%% ����MMPA-ELman��MPA-ELMan��ѵ������
figure
semilogy(tr.perf,'linewidth',1);
hold on
semilogy(tr1.perf,'r','linewidth',1.0);
legend('MPA-Elman','MMPA-Elman')
title('MPA-Elman��MMPA-Elman�ľ����������')
xlabel('ѵ������')
ylabel('�������')





