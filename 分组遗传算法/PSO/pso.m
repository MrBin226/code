clc;
clear;
%% 模型参数设置
binsize=100;%机器数
itemno=250;%虚拟机数量
R_cpu_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机cpu请求集合
R_mem_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机内存请求集合
R_disk_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机硬盘请求集合
R_cpu=randsample(R_cpu_set,itemno,1);%每个虚拟机对应的cpu请求大小
R_mem=randsample(R_mem_set,itemno,1);%每个虚拟机对应的内存请求大小
R_hardDisk=randsample(R_disk_set,itemno,1);%每个虚拟机对应的内存请求大小
% load data.mat
C_cpu=8;%每个机器对应的cpu大小
C_mem=8;%每个机器对应的内存大小
C_hardDisk=8;%每个机器对应的硬盘大小
itemindex=1:itemno;%虚拟机对应的编号

%% 算法参数设置
maxIter=100;%最大迭代次数
partical_size=100;%粒子数
c1=2;
c2=2;
w=0.9;
minfitness=zeros(maxIter,1);

%% 初始化粒子
[particals] = initPartical(partical_size,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% 计算适应度
[particals,best_pos,best_fitness,best_no] = pso_cal_fitness(particals,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% 开始迭代
for iter=1:maxIter
    for i=1:partical_size
        partical = particals(i);
        partical.speed=w*partical.speed + c1*rand()*(partical.best_pos-partical.pos) + c2*rand()*(best_pos-partical.pos);
        partical.speed=round(partical.speed);
        pos=partical.pos+partical.speed;
        pos(pos<1)=1;
        pos(pos>binsize)=binsize;
        [partical.pos,partical.BinNo]=correct(pos,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
        [par,~,~,~]=pso_cal_fitness(partical,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
        partical.fitness=par.fitness;
        if partical.fitness < partical.best_fitness
            partical.best_fitness = partical.fitness;
            partical.best_pos = partical.pos;
        end
        if partical.fitness<best_fitness
            best_fitness=partical.fitness;
            best_pos=partical.pos;
            best_no=partical.BinNo;
        end
        particals(i)=partical;
    end
    minfitness(iter)=best_fitness;
    fprintf('第%d次迭代，使用了%d台机器\n',iter,best_no);
end
plot(1:maxIter,minfitness)
xlabel('迭代次数')
ylabel('适应度值')
fprintf('最优解如下（共使用了%d台机器）：\n',best_no);
for k=1:best_no
    fprintf('分配到第%d台机器的虚拟机为：',k);
    ss = find(best_pos==k);
    for kk=1:length(ss)
        fprintf('%d  ',ss(kk));
    end
    fprintf('\n');
end











