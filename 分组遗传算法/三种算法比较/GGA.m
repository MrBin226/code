function [minfitness]=GGA(R_cpu,R_mem,R_hardDisk)
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
parentssize=floor(popsize*select_rate);%父代种群大小
minfitness=zeros(maxIter,1);

%% 初始化种群
[chromosome,BinNo] = GGA_initPoP(popsize,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% 计算适应度
fitnesses=GGA_cal_fitness(chromosome,BinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% 开始迭代
for iter=1:maxIter
    %% 二元锦标选择
    [parents,parentsBinNo,indices] = GGA_select(chromosome,parentssize,fitnesses,BinNo);
    %% 交叉
    [offspring,OffBinNo]=GGA_crossover(parents,parentssize,parentsBinNo,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    %% 变异
    for i=1:parentssize
        if rand() < mutratio
            [mutated,mutatedbinno]=GGA_mutate(offspring,i,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk,OffBinNo(i),itemno);
            for j=1:mutatedbinno
                offspring{i,j}=mutated{j};
            end
            for j=mutatedbinno+1:OffBinNo(i)
                offspring{i,j}=[];
            end
            OffBinNo(i)=mutatedbinno;
        end
    end
    new_fit=GGA_cal_fitness(offspring,OffBinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    [~,c1]=size(chromosome);
    [~,c2]=size(offspring);
    if c1>c2
        offspring(:,c2+1:c1)=cell(parentssize,c1-c2);
    else
        chromosome(:,c1+1:c2)=cell(parentssize,c2-c1);
    end
    all_pop=[chromosome;offspring];
    all_fit=[fitnesses;new_fit];
    all_no=[BinNo;OffBinNo];
    [~,s_idx]=sort(all_fit);
    chromosome=all_pop(s_idx(1:popsize),:);
    fitnesses=all_fit(s_idx(1:popsize),:);
    BinNo=all_no(s_idx(1:popsize),:);
    minfitness(iter)=min(fitnesses);
    [~,idx]=min(fitnesses);
%     fprintf('第%d次迭代，使用了%d台机器\n',iter,BinNo(idx));
end
% plot(1:maxIter,minfitness)
% xlabel('迭代次数')
% ylabel('适应度值')
% [~,colu]=size(chromosome);
% fprintf('最优解如下（共使用了%d台机器）：\n',BinNo(idx));
% for k=1:colu
%     if ~isempty(chromosome{1,k})
%         fprintf('分配到第%d台机器的虚拟机为：',k);
%         ss = chromosome{1,k};
%         for kk=1:length(ss)
%             fprintf('%d  ',ss(kk));
%         end
%         fprintf('\n');
%     end
% end

