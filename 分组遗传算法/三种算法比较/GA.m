function [minfitness]=GA(R_cpu,R_mem,R_hardDisk)
%% 模型参数设置
binsize=100;%机器数
itemno=250;%虚拟机数量
% R_cpu_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机cpu请求集合
% R_mem_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机内存请求集合
% R_cpu=randsample(R_cpu_set,itemno,1);%每个虚拟机对应的cpu请求大小
% R_mem=randsample(R_mem_set,itemno,1);%每个虚拟机对应的内存请求大小
C_cpu=8;%每个机器对应的cpu大小
C_mem=8;%每个机器对应的内存大小
C_hardDisk=8;%每个机器对应的硬盘大小
itemindex=1:itemno;%虚拟机对应的编号

%% 算法参数设置
maxIter=100;%最大迭代次数
popsize=100;%种群大小
select_rate=0.8;%选择概率
mutratio=0.3;%变异概率
minfitness=zeros(maxIter,1);

%% 初始化种群
[chromosome,BinNo] = initPoP(popsize,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% 计算适应度
fitness=cal_fitness(chromosome,BinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% 开始迭代
for iter=1:maxIter
    %% 二元锦标选择
    [parents,parentsBinNo,indices] = select(chromosome,select_rate,fitness,BinNo);
    %% 交叉
    [children,offeringNo] = crossover(parents,parentsBinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    %% 变异
    [new_children,mutionNo] = mution(children,offeringNo,mutratio,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    %% 选出下一代个体
    new_fit=cal_fitness(new_children,mutionNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    all_pop=[chromosome;new_children];
    all_fit=[fitness;new_fit];
    all_no=[BinNo;mutionNo];
    [~,idx]=sort(all_fit);
    chromosome=all_pop(idx(1:popsize),:);
    BinNo=all_no(idx(1:popsize));
    fitness=all_fit(idx(1:popsize));
    minfitness(iter)=fitness(1);
%     fprintf('第%d次迭代，使用了%d台机器\n',iter,BinNo(1));
end
% save f1.mat minfitness
% plot(1:maxIter,minfitness)
% xlabel('迭代次数')
% ylabel('适应度值')
% [~,colu]=size(chromosome);
% fprintf('最优解如下（共使用了%d台机器）：\n',BinNo(1));
% for k=1:BinNo(1)
%     fprintf('分配到第%d台机器的虚拟机为：',k);
%     ss = find(chromosome(1,:)==k);
%     for kk=1:length(ss)
%         fprintf('%d  ',ss(kk));
%     end
%     fprintf('\n');
% end












