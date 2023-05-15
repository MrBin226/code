clc;
clear;
close all;

%% 模型参数
adjacency=xlsread('data.xlsx','邻接矩阵','B2:V22');
trans_time=xlsread('data.xlsx','转移时间','B2:V22');
trans_time(isnan(trans_time))=0;

control_center=1;%控制中心的数量
skill_num=3;%技能类别数
person_matrix=[1	 0	1;1	 1	0;0	 1	1];%人员与技能矩阵
% control_center_people={[1 2 3],[4 5 6]};%各个控制中心的人员，人员编号
control_center_people={[1 2 3]};%各个控制中心的人员（单个控制中心的话只需要一个括号）
service_people=arrayfun(@(x) find(person_matrix(:,x)),1:skill_num,'UniformOutput',false);%各个技能对应的人员
service_people_of_center=zeros(1,size(person_matrix,1));%人员所属的控制中心
for i=1:control_center
    service_people_of_center(control_center_people{i})=i;
end
destory_task_num=14;%失效任务数量
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
destory_task_index=[18,19;15,10;15,14;15,16;15,19;14,9;14,13;14,18;14,15;9,8;9,10;9,14;8,4;8,13];%失效任务边
destory_task_skill=task_skill;

%% 模型参数
popsize=50;
MAXGEN=100;   %迭代次数
Pc=0.9;       %交叉概率
Pm=0.05;     %变异概率

%% 初始化种群
pop=initPoP(popsize,destory_task_num,service_people,skill_num,destory_task_skill);

%% 计算适应度函数
fitness=cal_fitness(pop,task_skill,trans_time,adjacency,service_people_of_center,destory_task_index,control_center);

min_fitness=zeros(MAXGEN,1);

%% 开始迭代
for iter=1:MAXGEN
    %% 选择(二元锦标选择)
    new_pop=select(pop,fitness);
    %% 顺序交叉
    new_pop=crossover(new_pop,Pc);
    %% 变异
    new_pop=mutation(new_pop,Pm,skill_num,service_people);
    %% 得到新的子代
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
    fprintf('第%d次迭代\n',iter);
end
figure(1)
plot(1:MAXGEN,min_fitness);
xlabel('迭代次数');
ylabel('总完工时间');
title('迭代过程');

[f,tt]=min(fitness);
fprintf('调度方案如下：（总完成时间为：%.2f）\n',f);
best_gen=pop{tt};
for i=1:destory_task_num
    if i==1
        fprintf('失效任务边执行顺序：（%d，%d）',destory_task_index(best_gen(1,i),1),destory_task_index(best_gen(1,i),2));
    else
        fprintf('-->（%d，%d）',destory_task_index(best_gen(1,i),1),destory_task_index(best_gen(1,i),2));
    end
end
fprintf('\n各个人员的调度方案：\n');
for i=1:size(person_matrix,1)
    fprintf('员工%d(控制中心%d)：',i,service_people_of_center(i));
    [~,col]=find(best_gen(2:end,:)==i);
    col=unique(col);
    if ~isempty(col)
        for j=1:length(col)
            fprintf('（%d，%d） ',destory_task_index(best_gen(1,col(j)),1),destory_task_index(best_gen(1,col(j)),2));
        end
    end
    fprintf('\n');
end











                
                