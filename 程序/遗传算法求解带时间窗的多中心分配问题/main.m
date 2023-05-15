clc;
clear;
close all;

%% ģ�Ͳ���
adjacency=xlsread('data.xlsx','�ڽӾ���','B2:V22');
trans_time=xlsread('data.xlsx','ת��ʱ��','B2:V22');
trans_time(isnan(trans_time))=0;

control_center=1;%�������ĵ�����
skill_num=3;%���������
person_matrix=[1	 0	1;1	 1	0;0	 1	1];%��Ա�뼼�ܾ���
% control_center_people={[1 2 3],[4 5 6]};%�����������ĵ���Ա����Ա���
control_center_people={[1 2 3]};%�����������ĵ���Ա�������������ĵĻ�ֻ��Ҫһ�����ţ�
service_people=arrayfun(@(x) find(person_matrix(:,x)),1:skill_num,'UniformOutput',false);%�������ܶ�Ӧ����Ա
service_people_of_center=zeros(1,size(person_matrix,1));%��Ա�����Ŀ�������
for i=1:control_center
    service_people_of_center(control_center_people{i})=i;
end
destory_task_num=14;%ʧЧ��������
task_skill=[1	1	0;...
            1	2	1;...
            0	1	3;...
            1	2	0;...
            2	3	0;...
            0	2	2;...
            0	4	1;...
            3	1	1;...
            2	0	1;...
            1	0	1;...
            1	3	1;...
            2	0	1;...
            1	2	0;...
            1	0	1];
destory_task_index=[18,19;15,10;15,14;15,16;15,19;14,9;14,13;14,18;14,15;9,8;9,10;9,14;8,4;8,13];%ʧЧ�����
destory_task_skill=task_skill;

%% ģ�Ͳ���
popsize=50;
MAXGEN=100;   %��������
Pc=0.9;       %�������
Pm=0.05;     %�������

%% ��ʼ����Ⱥ
pop=initPoP(popsize,destory_task_num,service_people,skill_num,destory_task_skill);

%% ������Ӧ�Ⱥ���
fitness=cal_fitness(pop,task_skill,trans_time,adjacency,service_people_of_center,destory_task_index,control_center);

min_fitness=zeros(MAXGEN,1);

%% ��ʼ����
for iter=1:MAXGEN
    %% ѡ��(��Ԫ����ѡ��)
    new_pop=select(pop,fitness);
    %% ˳�򽻲�
    new_pop=crossover(new_pop,Pc);
    %% ����
    new_pop=mutation(new_pop,Pm,skill_num,service_people);
    %% �õ��µ��Ӵ�
    new_fit=cal_fitness(new_pop,task_skill,trans_time,adjacency,service_people_of_center,destory_task_index,control_center);
    all_pop=[pop;new_pop];
    all_fit=[fitness;new_fit];
    [~,idx]=sort(all_fit);
    pop=all_pop(idx(1:popsize));
    [~,k] = unique(cellfun(@char,cellfun(@getByteStreamFromArray,pop,'un',0),'un',0),'stable');
    pop=pop(k);
    if length(pop)<popsize
        rand_pop=initPoP(length(setdiff(1:popsize,k)),destory_task_num,service_people,skill_num,destory_task_skill);
        pop=[pop;rand_pop];
    end
    fitness=cal_fitness(pop,task_skill,trans_time,adjacency,service_people_of_center,destory_task_index,control_center);
    min_fitness(iter)=min(fitness);
    fprintf('��%d�ε���\n',iter);
end
figure(1)
plot(1:MAXGEN,min_fitness);
xlabel('��������');
ylabel('���깤ʱ��');
title('��������');

[f,tt]=min(fitness);
fprintf('���ȷ������£��������ʱ��Ϊ��%.2f��\n',f);
best_gen=pop{tt};
for i=1:destory_task_num
    if i==1
        fprintf('ʧЧ�����ִ��˳�򣺣�%d��%d��',destory_task_index(best_gen(1,i),1),destory_task_index(best_gen(1,i),2));
    else
        fprintf('-->��%d��%d��',destory_task_index(best_gen(1,i),1),destory_task_index(best_gen(1,i),2));
    end
end
fprintf('\n������Ա�ĵ��ȷ�����\n');
for i=1:size(person_matrix,1)
    fprintf('Ա��%d(��������%d)��',i,service_people_of_center(i));
    [~,col]=find(best_gen(2:end,:)==i);
    col=unique(col);
    if ~isempty(col)
        for j=1:length(col)
            fprintf('��%d��%d�� ',destory_task_index(best_gen(1,col(j)),1),destory_task_index(best_gen(1,col(j)),2));
        end
    end
    fprintf('\n');
end











                
                