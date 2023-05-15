clc;
clear;
close all;
%% ģ�Ͳ�������
data=xlsread('data.xls');
a = unique(data(:,1:2),'rows','stable');
b = arrayfun(@(x) sum(data(data(:,1:2) == a(x),3)),1:length(a));
data = [(1:length(a))',a,b'];
c = arrayfun(@(x) randi(b(x)+2)-1,1:length(b));
data=[data,c'];
h=pdist(data(:,2:3));
dist=squareform(h);%����վ���ľ���
num=size(data,1);%վ�����

%% �㷨��������
q=0.5;%��ȴϵ��
T0=100;%��ʼ�¶�
Tf=2;%��ֹ�¶�
T=T0;%��ǰ�¶�
Markov_length=100;%����ɷ����ĳ���
popsize=25;%��Ⱥ��С
crossover_rate=0.9;%�������
mutate_rate=0.2;%�������

%% ��ʼ����Ⱥ
[pop,car_now] = initPop(popsize,num,data);

%% ������Ӧ�Ⱥ���
fitness = cal_fitness(pop,data,dist,car_now);
[E_best,idx]=min(fitness);
sol_best=pop(idx,:);
min_fitness=[];
iter=1;
%% ��ʼ����
while Tf<=T
    [pop,car_now] = initPop(popsize,num,data);
    fitness = cal_fitness(pop,data,dist,car_now);
    for i=1:Markov_length
        %ѡ��:��Ԫ����ѡ��
        [new_pop,select_idx]=select(pop,fitness);
        %����
        new_pop=crossover(new_pop,crossover_rate);
        %����
        new_pop=mutation(new_pop,mutate_rate,data,dist);
        cars_now=cal_final_cars(new_pop,data);
        new_fit=cal_fitness(new_pop,data,dist,car_now);
        for k=1:popsize
            if new_fit(k)<=fitness(select_idx(k))
                pop(select_idx(k),:)=new_pop(k,:);
                fitness(select_idx(k))=new_fit(k);
                if new_fit(k)<E_best
                    E_best=new_fit(k);
                    sol_best=new_pop(k,:);
                end
            else
                 if rand() < exp(-(new_fit(k)-fitness(select_idx(k)))/T)
                     pop(select_idx(k),:)=new_pop(k,:);
                     fitness(select_idx(k))=new_fit(k);
                 end
            end
        end
    end
    T=0.99*T;
    min_fitness=[min_fitness E_best];
    fprintf('��%d�ε�����������Ӧ��ֵΪ%.4f\n',iter,E_best);
    iter=iter+1;
end
figure()
hold on
plot(1:length(min_fitness),min_fitness)
xlabel('��������')
ylabel('��Ӧ��ֵ')
title('��������')
hold off
disp('���ŷ���Ϊ��')
for i=1:num
    if sol_best{i}~=[0;0]
        a=sol_best{i};
        for k=1:size(a,2)
            fprintf('վ��%d��վ��%d��������%d��\n',i,a(1,k),a(2,k));
        end
    end
end

























