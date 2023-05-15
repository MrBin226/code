clc;
clear;
tic
%% �����������
w_len=9;%W�����ȫ��Ԫ�ظ���
%���ڳ�ʼ��
w =[0.0922193973630614,-0.00110595318277262,0.0234449494988418;0.0471691430333492,0.0579241010335920,0.00133658921661350;-0.00575899047346251,-0.00449380033575153,0.148292539942199];
% ��w��Ϊ������
w=reshape(w,1,w_len);
w_max=0.15;%W�����ֵ
w_min=-0.15;%W����Сֵ
minRealVal=ones(1,w_len)*w_max;
maxRealVal=ones(1,w_len)*w_min;
[rgb,xyz]=produce_data();%�õ�RGBֵ����XYZֵ
wlength = [400 10 700];
lsource = 'D65';   
system = 1964;
if (system == 1964)
    load xyz1964.dat; st = xyz1964;
else
    load xyz1931.dat; st = xyz1931;
end
load lsources.dat;

%% �Ŵ��㷨��������
max_iter=1000;%����������
popsize=100;%��Ⱥ����
select_rate=0.9;%ѡ�����
crossover_rate=0.9;%�������
mutate_rate=0.1;%�������
cross_n = 1; % ģ�⽻�����ӵķֲ�����
N_m = 10;   % ����ʽ�����еķֲ�ָ��
min_fitness=zeros(max_iter,1);

%% ��ʼ����Ⱥ
pop = initPop(popsize,w,w_len);

%% ��Ӧ�Ⱥ�������
fitness = cal_fitness(pop,wlength,lsource,system,rgb,xyz,lsources,st);
[~,idx]=min(fitness);
best_pop=pop(idx,:);

%% ��ʼ����
for iter=1:max_iter
    %% ��Ԫ����ѡ�����
    new_pop = select(pop,fitness,select_rate);
    %% ģ�⽻��
    new_pop = crossover(new_pop,crossover_rate,wlength,lsource,system,rgb,xyz,lsources,st);
    %% ����ʽ����
    if iter > max_iter/4 && iter < max_iter/2
        new_pop = mutation(new_pop,best_pop,new_pop(1,:),mutate_rate);
    end
    if iter <=max_iter/4 || iter >= max_iter/2
        new_pop = mutation1(new_pop,minRealVal,maxRealVal,mutate_rate,N_m);
    end
    %% �������ĸ�������Ⱥ�����һ��ѡ����Ӧ�ȸ��ŵĸ�����Ϊ�Ӵ�
    new_fit = cal_fitness(new_pop,wlength,lsource,system,rgb,xyz,lsources,st);
    
    [fitness,idx]=sort(fitness);
    fitness = [fitness(1:popsize-popsize*select_rate);new_fit];
    pop=[pop(idx(1:popsize-popsize*select_rate),:);new_pop];
    [fitness, idx]=sort(fitness);
    pop = pop(idx,:);
    min_fitness(iter)=fitness(1);
    fprintf('��%d�ε�������Ӧ��ֵΪ%.2f\n',iter,fitness(1));
    crossover_rate = 0.9-0.2*(iter/max_iter);
    mutate_rate = 0.1+0.5*(iter/max_iter);
    best_pop=pop(1,:);
end
figure()
hold on
plot(1:max_iter,min_fitness)
xlabel('��������')
title('�Ż�����')
ylabel('��Ӧ��ֵ')
hold off
disp('���յ�M��');
disp(reshape(pop(1,:),3,6))
toc










