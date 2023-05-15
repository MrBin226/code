clc;
clear;
close all;

%% ģ������
data=xlsread('����.xlsx','A1:D1002');
data1=readtable('T.txt');
xx=[data1.x data1.y];
order=data1.order;
for ii=1:size(xx,1)
disp('----------------------------------------');
fprintf('��%d��',ii);
C=xx(ii,:);%�������������
% ������һ��ĸ����˿ͱ��
cum=str2num(char(split(order{ii},',')))';
demand=data(cum+1,4);%�ͻ���������
vertexs=[C;data(cum+1,2:3)];%���е������x��y
vehicle_model=2;%�����ͺ���
vehicle_cap=[24.1,3.8];%��Ӧ��������������
customer=vertexs(2:end,:);%�˿�����
cusnum=size(customer,1); %�˿���
vehicle_num=[60,20];%��������
vehicle_start_cost=[120,30];%�������óɱ�
transport_cost=[1.68,0.7];%���䵥λ����ɱ�
w1=[0.25,0.41;0.13,0.32];%���غ����ص�λ�������ȼ�����ĵĳɱ�
w2=6.29;%�ͼ�
% w=3;%�˹����ͳɱ�
h=pdist(vertexs);
dist=squareform(h);                 %�������
% h1=pdist(data(2:end,2:3));
% dist1=squareform(h1);                 %�������
% people_cost=arrayfun(@(x) w*dist1(data1.index1(x),data1.index2(x)),1:length(demand));
% people_cost=sum(people_cost);

%% �Ŵ��㷨��������
popsize=50;                                                    %��Ⱥ��С
MAXGEN=500;                                                     %��������
Pc=0.9;                                                        %�������
Pm=0.05;                                                       %�������

%% ��ʼ����Ⱥ
[pop_x,pop_y]=initPoP(popsize,cusnum,vehicle_num,vehicle_model);

%% ������Ӧ��
fitness=cal_fitness(pop_x,pop_y,demand,dist,vehicle_cap,vehicle_start_cost,transport_cost,w1,w2);

min_fitness=zeros(MAXGEN,1);

%% ��ʼ����
for iter=1:MAXGEN
    %% ѡ��(��Ԫ����ѡ�����)
    [new_pop_x,new_pop_y]=select(pop_x,pop_y,fitness);
    %% ����(new_pop_x����ox������ԣ�new_pop_y���õ��㽻��)
    [new_pop_x,new_pop_y]=crossover(new_pop_x,new_pop_y,Pc,demand,vehicle_cap);
    [new_pop_y] = adjustPoP(new_pop_x,new_pop_y,vehicle_model,vehicle_num,demand,vehicle_cap);
    %% ����(new_pop_x���÷�תͻ�䣬new_pop_y���õ������)
    [new_pop_x,new_pop_y]=Mutate(new_pop_x,new_pop_y,Pm,demand,vehicle_cap,vehicle_model);
    [new_pop_y] = adjustPoP(new_pop_x,new_pop_y,vehicle_model,vehicle_num,demand,vehicle_cap);
    %% �����µ��Ӵ�
    new_fit=cal_fitness(new_pop_x,new_pop_y,demand,dist,vehicle_cap,vehicle_start_cost,transport_cost,w1,w2);
    all_pop_x=[pop_x;new_pop_x];
    all_pop_y=[pop_y;new_pop_y];
    all_fit=[fitness;new_fit];
    [~,idx]=sort(all_fit);
    pop_x=all_pop_x(idx(1:popsize),:);
    pop_y=all_pop_y(idx(1:popsize),:);
    [~,k] = unique(pop_x,'rows','stable');
    pop_x=pop_x(k,:);
    pop_y=pop_y(k,:);
    if size(pop_x,1)<popsize
        [rand_pop_x,rand_pop_y]=initPoP(length(setdiff(1:popsize,k)),cusnum,vehicle_num,vehicle_model);
        pop_x=[pop_x;rand_pop_x];
        pop_y=[pop_y;rand_pop_y];
    end
    fitness=cal_fitness(pop_x,pop_y,demand,dist,vehicle_cap,vehicle_start_cost,transport_cost,w1,w2);
    min_fitness(iter)=min(fitness);
%     fprintf('��%d�ε���\n',iter);
end
% figure(ii)
% plot(min_fitness,'LineWidth',1);
% title('ȫ�����Ž�ľ���仯����ͼ')
% xlabel('��������');
% ylabel('�ܳɱ�');

[minCost,minInd]=min(fitness);
fprintf('�����ܳɱ�Ϊ��%.2f\n',minCost);
[VC,num,vc_model]=decode(pop_x(minInd,:),pop_y(minInd,:),demand,vehicle_cap);
disp('��ʻ�������£�')
for i=1:num
    fprintf('��%d�������ͺ�Ϊ%d����',i,vc_model(i));
    r=VC{i};
    for j=1:length(r)
        fprintf('%d  ',cum(r(j)));
    end
    fprintf('\n');
end
end













