clc;
clear;
close all;

%% ģ�Ͳ�������
lb = [50 * 10000, 40 * 10000, 30 * 10000]; %��l�����ʴ������½�
ub = [100 * 10000, 70 * 10000, 40 * 10000]; %��l�����ʴ������Ͻ�
C = 3; %���ǵȼ�
S = 500; %�ܳ�����
L = 3; %������ȼ�
pur = 10 * 10000;%Ӧ�����ʵ�λ�ɹ��ɱ���Ԫ/�򹫽
stro = 4 * 10000;%Ӧ�����ʵ�λ�洢�ɱ���Ԫ/�򹫽
h = 0.0012 * 10000;%Ӧ�����ʵ�λ��������ɱ���Ԫ/�򹫽�*���
c = [1000 * 10000, 800 * 10000, 600 * 10000];%��l��Ӧ��������Ľ��輰ά���ɱ�
D = [30, 60, 120]; % c�����������������
p = [0.9, 0.8, 0.7;0.6, 0.5, 0.4;0.3, 0.2, 0.1];%����㸲�ǵȼ�c��Ӧ�����ʴ����⽨��ȼ�l��Ӧ�ĸ�����
rho = [0.53, 0.33, 0.14];%���ǵȼ�c��Ӧ�ĸ�����Ȩ��
P_s = 1/S; %�����������ĸ���

distance = xlsread('����.xlsx','����');%��ѡ�㵽���������ľ���
demand = xlsread('����.xlsx','������������');%���������¸�������������
demand = demand * 10000;
% �õ������⸲�ǵȼ��жϾ���
theta=cell(1,C);
for i=1:C
    if i==1
        theta{i}=double(distance<=D(i));
    else
        theta{i}=double(distance<=D(i) & distance>D(i-1));
    end
end
% ������ܷ񱻺�ѡ�㸲���жϾ���
A=double(distance<=D(end));

%% �㷨��������
max_iter=10;%����������
popsize=50;%��Ⱥ����
cross_rate=0.9;%�������
mutate_rate=0.01;%�������

%% ��ʼ����Ⱥ
pop=initPoP(popsize,A,L);

%% ��Ӧ�ȼ���
ObjV=cal_fitness(pop,distance,demand,A,ub,lb,C,S,L,pur,stro,h,c,P_s,theta,rho,p);

Generation=1;
min_fitness=zeros(max_iter,1);
while Generation <= max_iter
    %% ѡ��
    SelCh = select(pop,ObjV);
    %% �������
    SelCh=crossover(SelCh,cross_rate,A,L);
    %% ����
    SelCh=Mutate(SelCh,mutate_rate,A,L);
    %% ɸѡ����һ���Ӵ�
    all_pop = [pop;SelCh];
    new_ObjV=cal_fitness(SelCh,distance,demand,A,ub,lb,C,S,L,pur,stro,h,c,P_s,theta,rho,p);
    all_ObjV=[ObjV;new_ObjV];
    [~,idx]=sort(all_ObjV);
    ObjV=all_ObjV(idx(1:popsize));
    pop=all_pop(idx(1:popsize));
    min_fitness(Generation)=ObjV(1);
    fprintf('��%d�ε���\n',Generation);
    Generation = Generation+1;
end
plot(1:max_iter,min_fitness);
xlabel('��������')
ylabel('��Ӧ��ֵ')
title('�Ż�����')
[solution] = decode(pop{1},distance,demand,A,ub,lb);
plan=solution.deliver_plan;
select_place=find(pop{1}(1,:)==1);
bulild_class=pop{1}(2,select_place);
fprintf('�������£�\n');
fprintf('ѡ����');
for i=1:length(select_place)
    fprintf('%d��������%d,',bulild_class(i),select_place(i));
end
fprintf('\n');
for i=1:S
    p=plan{i};
    fprintf('����%d�£�',i);
    for j=1:size(p,1)
        fprintf('������%d�������%d����%d  ',p(j,1),p(j,2),p(j,3));
    end
    fprintf('\n');
end





