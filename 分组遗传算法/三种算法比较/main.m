clc;
clear;
close all;
itemno=250;%���������
R_cpu_set=[0.25,0.5,1,1.5,2,2.5,3,4];%�����cpu���󼯺�
R_mem_set=[0.25,0.5,1,1.5,2,2.5,3,4];%������ڴ����󼯺�
R_disk_set=[0.25,0.5,1,1.5,2,2.5,3,4];%�����Ӳ�����󼯺�
R_cpu=randsample(R_cpu_set,itemno,1);%ÿ���������Ӧ��cpu�����С
R_mem=randsample(R_mem_set,itemno,1);%ÿ���������Ӧ���ڴ������С
R_hardDisk=randsample(R_disk_set,itemno,1);%ÿ���������Ӧ���ڴ������С
tic;
[f1]=pso(R_cpu,R_mem,R_hardDisk);
toc;
fprintf('pso��Ӧ��ֵΪ%.1f\n',f1(end))
tic;
[f2]=GA(R_cpu,R_mem,R_hardDisk);
toc;
fprintf('GA��Ӧ��ֵΪ%.1f\n',f2(end))
tic;
[f3]=GGA(R_cpu,R_mem,R_hardDisk);
toc;
fprintf('GGA��Ӧ��ֵΪ%.1f\n',f3(end))
hold on
plot(1:100,f1,'m',1:100,f2,'blue',1:100,f3,'r')
xlabel('��������')
ylabel('��Ӧ��ֵ')
title('��������')
legend('PSO','GA','GGA')
hold off
