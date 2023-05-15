clc;
clear;
close all;
%% ģ�Ͳ�������
ub=[12.5,80,33,2.7];%���߱����Ͻ�
lb=[8.5,70,25,2.1];%���߱����½�
varible_num=4;%��������
fismat=readfis('qingjiedu.fis');%��ȡfis�ļ�

%% �㷨��������
q=0.5;%��ȴϵ��
T0=100;%��ʼ�¶�
Tf=2;%��ֹ�¶�
T=T0;%��ǰ�¶�
Markov_length=50;%����ɷ����ĳ���
popsize=25;%��Ⱥ��С
mutate_rate=0.1;%�������
crossover_rate=0.9;
N_m = 10;   % ����ʽ�����еķֲ�ָ��
sol_best=arrayfun(@(x) rand().*(ub(x)-lb(x))+lb(x),1:varible_num);%ȫ�����Ÿ���
E_best = cal_fitness(sol_best,fismat);
min_fitness=[];
iter=1;
%% ��ʼ����
while Tf<=T
    %% ��ʼ����Ⱥ
    pop = initPop(popsize,varible_num,ub,lb);
    %% ��Ӧ�ȼ���
    fitness = cal_fitness(pop,fismat);
    %% �Ŵ�Ѱ��
    for i=1:Markov_length
        %ѡ��:��Ԫ����ѡ��
        [new_pop,select_idx]=select(pop,fitness);
        %ģ������ƽ���
%         new_pop=crossover(new_pop,cross_n );
        [new_pop] = crossover1(new_pop,crossover_rate,fismat,ub,lb);
        %����ʽ����
        new_pop=mutation (new_pop,lb,ub,mutate_rate,N_m);
        new_fit=cal_fitness(new_pop,fismat);
        for k=1:popsize
            if new_fit(k)>=fitness(select_idx(k))
                pop(select_idx(k),:)=new_pop(k,:);
                fitness(select_idx(k))=new_fit(k);
                if new_fit(k)>E_best
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
    T=q*T;
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
disp(sol_best);
disp('C:');
disp(evalfis(sol_best(1,:),fismat));
disp('0.011304*l*t:');
disp(0.011304*sol_best(1,3)*sol_best(1,4));
disp('0.0009324*l^2*sin(deg2rad(a)):');
disp(0.0009324*sol_best(1,3)^2*sin(deg2rad(sol_best(1,2))));
disp('0.37*t:');
disp(0.37*sol_best(1,4));

























