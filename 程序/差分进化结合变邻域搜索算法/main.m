clc;
clear;
close all;

%% ��ȡ�������
% order_data=importfile('order.txt',',');%��������
% due_time=importfile('due.txt',',');%������ֹʱ��
% due_time=cell2mat(due_time);
order_data=arrayfun(@(x) randperm(100,randi([4 6])),1:30,'UniformOutput',0)';
due_time=randi([10,100],30,1);
shelve_data=reshape(1:100,5,20)';%�����ϴ����Ʒ��Ϣ
shelve_data=num2cell(shelve_data,2);

%% ����ģ����ز���
order_num=size(order_data,1);%��������
C=6;%ÿ�������е���󶩵�����
E=2;%ÿ�������е���С��������
batch_num=order_num;%���������
t1=6;%�ƶ������˰���һ�λ��ܵ�ʱ��
t2=1;%���Ա��ѡһ��SKU��ʱ��
lambda=0.3;%��Ȩ���ƶȲ���

%% �㷨��ز�������
chromosome_length=order_num+batch_num-1;%Ⱦɫ�峤��Ϊ������+���������-1
NP=30;%��Ⱥ����
F=0.5;%��������
CR=0.8;%�������
max_iter=50;%����������
len=floor(order_num/3);
min_fitness=zeros(max_iter,1);
best_sol=[];
best_fit=inf;

%% ���㶩���ļ�Ȩ���ƶ�
order_similarity=cal_order_similarity(order_data);
shelve_similarity=cal_shelve_similarity(order_data,shelve_data);
weight_similarity=lambda*order_similarity+(1-lambda)*shelve_similarity;

%% ��Ⱥ��ʼ��
[chromesome] = initPop(NP,chromosome_length,order_num,order_data,shelve_data,E,C,t1,t2,weight_similarity);

%% ����Ŀ�꺯��
[fitness] = cal_fitness(chromesome,order_data,shelve_data,due_time,t1,t2,C,E);

%% ��ʼ����
for iter=1:max_iter
    % ����
    [V] = mutation(chromesome,F,order_num,batch_num,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data);
    % ����
    [V] = crossover(chromesome,V,CR,fitness,order_data,shelve_data,due_time,t1,t2,C,E,weight_similarity);
    % ����������
    chromesome = LargeSearch(V,len,order_num,E,C,order_data,shelve_data,due_time,t1,t2,weight_similarity);
    % ����Ŀ�꺯��
    [fitness] = cal_fitness(chromesome,order_data,shelve_data,due_time,t1,t2,C,E);
    [~,idx]=min(fitness);
    if best_fit > fitness(idx)
        best_sol=chromesome(idx,:);
        best_fit=fitness(idx);
    end
    min_fitness(iter)=best_fit;
    fprintf('��%d�ε�����Ŀ�꺯��Ϊ��%d\n',iter,best_fit);
end

[order_batch] = decode(best_sol);
disp('����������£�');
for i=1:length(order_batch)
    fprintf('��%d������:',i);
    temp=order_batch{i};
    for j=1:length(temp)
        fprintf('%d  ',temp(j));
    end
    fprintf('\n');
end

figure(1)
plot(1:max_iter,min_fitness);
xlabel('��������');
ylabel('Ŀ�꺯��');
title('��������')





















