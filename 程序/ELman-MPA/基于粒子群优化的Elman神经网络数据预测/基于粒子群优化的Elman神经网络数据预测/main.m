% ����PSO-Elman������ĵ�������Ԥ��ģ���о�
%% by Jack�� �� https://mianbaoduo.com/o/bread/mbd-YZaTlppv
%% ��ջ�������
clc;
clear all
close all
nntwarn off;
%% ��������
load data;
a=data;
%% ѡȡѵ�����ݺͲ�������
for i=1:6
    p(i,:)=[a(i,:),a(i+1,:),a(i+2,:)];
end
% ѵ����������
p_train=p(1:5,:);
% ѵ���������
t_train=a(4:8,:);
% ������������
p_test=p(6,:);
% �����������
t_test=a(9,:);

% Ϊ��Ӧ����ṹ ��ת��
p_train=p_train';
t_train=t_train';
p_test=p_test';


%% ������ز����趨
hiddNum = 18;%���������
R = size(p_train,1);%��������ÿ���ά��
Q = size(t_train,1);%������ݵ�ά��
threshold = [0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1;0 1];%ÿ�����ݶ�Ӧά�ȵ���С��0�������ֵ��1��;

%% ����Ⱥ��ز����趨
%% ��������Ⱥ�Ż�����
pop=20; %��Ⱥ����
Max_iteration=30; %  �趨����������
dim = hiddNum*R + hiddNum + Q + hiddNum*hiddNum + Q*hiddNum;%ά�ȣ���Ȩֵ����ֵ�ĸ������нӲ����
lb = -1;%�±߽�
ub = 1;%�ϱ߽�
Vmax = 0.5;
Vmin = -0.5;
fobj = @(x) fun(x,hiddNum,R,Q,threshold,p_train,t_train,p_test,t_test);
[Best_pos,Best_score,PSO_curve,net]=PSO(pop,Max_iteration,lb,ub,dim,fobj,Vmax,Vmin); %��ʼ�Ż�
%��ȡ����Ȩֵ����ֵʱ�����磬�Լ��Բ������ݵ�Ԥ�����
% Ԥ������
y=sim(net,p_test);
% �������
error = y'-t_test;
ESum = sum(abs(error));

%% ���û���Elman����Ԥ��
% ����Elman������ ���ز�ΪhiddNum����Ԫ
net1=newelm(threshold,[hiddNum,Q],{'tansig','purelin'});
% ��������ѵ������
net1.trainparam.epochs=100;
net1.trainParam.showWindow = false; 
net1.trainParam.showCommandLine = false; 
 % ��ʼ������
 net1=init(net1);
% Elman����ѵ��
net1=train(net1,p_train,t_train);
% Ԥ������
y1=sim(net1,p_test);
% �������
error1 = y1'-t_test;
ESum1 = sum(abs(error1));

%% ͨ����ͼ �۲첻ͬ���ز���Ԫ����ʱ�������Ԥ��Ч��
figure
plot(abs(error),'ro-','linewidth',2);
hold on
plot(abs(error1),'b*-','linewidth',2);
title('ElmanԤ��������ͼ')
set(gca,'Xtick',[1:3])
legend('PSO-Elman','ԭʼElman')
xlabel('ʱ���')
ylabel('���')
hold off;
grid on;
disp(['ԭʼElman�ľ������ͣ�',num2str(ESum1)])
disp(['PSO-Elman�ľ������ͣ�',num2str(ESum)])


%% ��������Ⱥ��������
figure
plot(PSO_curve,'linewidth',1.5);
title('����Ⱥ��������')
xlabel('��������')
ylabel('��Ӧ��ֵ')
grid on
