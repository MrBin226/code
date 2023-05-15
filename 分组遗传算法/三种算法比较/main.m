clc;
clear;
close all;
itemno=250;%虚拟机数量
R_cpu_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机cpu请求集合
R_mem_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机内存请求集合
R_disk_set=[0.25,0.5,1,1.5,2,2.5,3,4];%虚拟机硬盘请求集合
R_cpu=randsample(R_cpu_set,itemno,1);%每个虚拟机对应的cpu请求大小
R_mem=randsample(R_mem_set,itemno,1);%每个虚拟机对应的内存请求大小
R_hardDisk=randsample(R_disk_set,itemno,1);%每个虚拟机对应的内存请求大小
tic;
[f1]=pso(R_cpu,R_mem,R_hardDisk);
toc;
fprintf('pso适应度值为%.1f\n',f1(end))
tic;
[f2]=GA(R_cpu,R_mem,R_hardDisk);
toc;
fprintf('GA适应度值为%.1f\n',f2(end))
tic;
[f3]=GGA(R_cpu,R_mem,R_hardDisk);
toc;
fprintf('GGA适应度值为%.1f\n',f3(end))
hold on
plot(1:100,f1,'m',1:100,f2,'blue',1:100,f3,'r')
xlabel('迭代次数')
ylabel('适应度值')
title('迭代过程')
legend('PSO','GA','GGA')
hold off
