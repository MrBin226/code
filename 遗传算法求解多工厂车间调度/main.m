clc;
clear;
close all;

%% ģ�Ͳ�������
F=3;%3������
c=3;%3������
m_k={[3,3,2],[2,3,2],[2,3,2]};%����������k�׶εĻ�������
n=8;%������
% p_ijk={[2,4,6;4,9,2;4,2,8;9,5,6;5,2,7;9,4,3;8,7,4;6,3,5],...
%        [3,3,5;2,8,4;3,3,7;10,6,4;4,3,8;9,5,2;6,5,8;3,8,6],...
%        [1,5,5;4,8,4;2,5,9;9,5,4;5,1,8;8,4,2;7,6,4;5,7,5]};%���������ڸ���������Ӧ��������ļӹ�ʱ��
p_ijk=cell(1,F);
for i=1:F
    p_ij=importdata(['����',num2str(i),'.txt']);
    p_ijk{i}=p_ij.data;
end

%% �Ŵ��㷨��������
popsize=100;%��Ⱥ����
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








