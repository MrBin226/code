clc;
clear;
close all;

%% ģ�Ͳ�������
F=3;%������
c=5;%������
m_k={[1,3,2,2,1],[2,1,2,3,2],[2,1,2,3,3]};%����������k�׶εĻ�������
n=18;%������
% p_ijk={[];[];[]};%���������ڸ���������Ӧ��������ļӹ�ʱ��
p_ijk=cell(1,F);
for i=1:F
    p_ij=importdata(['����',num2str(i),'.txt']);
    p_ijk{i}=p_ij.data;
end

%% �Ŵ��㷨��������
popsize=10;%��Ⱥ����
max_iter=100;%����������
cross_rate=0.7;%�������
mutate_rate=0.05;%�������
min_fitness=zeros(max_iter,1);

%% ��ʼ����Ⱥ
pop=initPoP(popsize,F,n);

%% ��Ӧ�ȼ���
fitness=cal_fitness(pop,c,m_k,p_ijk);

%% ��������
for iter=1:max_iter
    %% ���̶�ѡ��
    new_pop=select(pop,fitness);
    %% ����
    new_pop=crossover(new_pop,cross_rate,n);
    %% ����
    new_pop=mution(new_pop,mutate_rate);
    %% ɸѡ���Ӵ�
    new_fit=cal_fitness(new_pop,c,m_k,p_ijk);
    all_pop=[pop;new_pop];
    all_fit=[fitness;new_fit];
    [x,idx]=sort(all_fit,'descend');
    pop=all_pop(idx(1:popsize),:);
    fitness=all_fit(idx(1:popsize));
    min_fitness(iter)=fitness(1);
end
figure(1)
plot(1:max_iter,min_fitness);
xlabel('��������')
ylabel('��Ӧ��ֵ')
title('��������')
fprintf('������ʱ��Ϊ��%.2f\n',1/fitness(1));
for i=1:F
    [scheme,time]=decode(pop{1,i},c,m_k{i},p_ijk{i});
    fprintf('��%d����������������(�ù���������ʱ��Ϊ��%.2f):',i,time);
    disp(pop{1,i});
    draw(pop{1,i},scheme,m_k{i},time,p_ijk{i},i);
end








