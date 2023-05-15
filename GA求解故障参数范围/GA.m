clc;
clear;
close all;

%% ģ�Ͳ�������
a = 0.05; % �ݲΧ
R1 = 1;
R3 = 1;
R4 = 1;
R5 = 1;
R6 = 1;
C1 = 0.1;
C2 = 0.1;%��λ0.1uF
R2_min = 1 * 10^(-4);
R2_max = 10; % 10ǧŷΪ��λ
M = 0.9484 - 0.8283i;
f = 1; % Ƶ��Ϊ1KHZ
minRealVal=[R1*(1-a),R2_min,R3*(1-a),R4*(1-a),R5*(1-a),R6*(1-a),C1*(1-a),C2*(1-a)];%������������Сֵ
maxRealVal=[R1*(1+a),R2_max,R3*(1+a),R4*(1+a),R5*(1+a),R6*(1+a),C1*(1+a),C2*(1+a)];%�������������ֵ

%% �Ŵ���������
N = 100; % ��Ⱥ��Ŀ
G = 500; % ��������
gen_len = 8; % Ⱦɫ�峤��
cross_n = 1; % ģ�⽻�����ӵķֲ�����
mutation_rate = 0.1; % ������
N_m = 4;   % ����ʽ�����еķֲ�ָ��

%% ��ʼ����Ⱥ
pop = initPoP(N,gen_len,R1,R2_min,R2_max,R3,R4,R5,R6,C1,C2,a);

%% ������Ӧ��
fitness = cal_fitness( pop,f,M);

%% �㷨����
iter=1;
record_fit=zeros(G,1);
while iter <= G
    % ģ������ƽ�������
    new_pop = crossover( pop,cross_n );
    % ����ʽ����
    new_pop = mutation (new_pop,minRealVal,maxRealVal,mutation_rate,N_m);
    % �����Ӵ�����Ӧ��
    new_fitness = cal_fitness( new_pop,f,M);
    % �ϲ���Ⱥ
    all_pop = [pop;new_pop];
    all_fit = [fitness;new_fitness];
    % ������Ӧ��С��0.01*abs(M)�ĸ���
    D = sum(all_fit<=0.01*abs(M));
    % ѡ���Ӵ�
    pop=select(all_pop,all_fit,N,D,M);
    fitness=cal_fitness( pop,f,M);
    record_fit(iter)=min(fitness);
    iter = iter + 1;
end
%����ɢ��ͼ�������2��ʾ������R2
scatter(pop(fitness<0.01*abs(M),2),fitness(fitness<0.01*abs(M)))
xlabel('fault parameter(��λ10K��)')
ylabel('g')
ub_lb = pop(fitness<=0.001,:);
fprintf('��������Ϊ��%.2fK��,��������Ϊ��%.2fK��\n',max(ub_lb(:,2))*10,min(ub_lb(:,2))*10);












