clc;
clear;
%% ģ�Ͳ�������
binsize=100;%������
itemno=250;%���������
R_cpu_set=[0.25,0.5,1,1.5,2,2.5,3,4];%�����cpu���󼯺�
R_mem_set=[0.25,0.5,1,1.5,2,2.5,3,4];%������ڴ����󼯺�
R_disk_set=[0.25,0.5,1,1.5,2,2.5,3,4];%�����Ӳ�����󼯺�
R_cpu=randsample(R_cpu_set,itemno,1);%ÿ���������Ӧ��cpu�����С
R_mem=randsample(R_mem_set,itemno,1);%ÿ���������Ӧ���ڴ������С
R_hardDisk=randsample(R_disk_set,itemno,1);%ÿ���������Ӧ���ڴ������С
% load data.mat
C_cpu=8;%ÿ��������Ӧ��cpu��С
C_mem=8;%ÿ��������Ӧ���ڴ��С
C_hardDisk=8;%ÿ��������Ӧ��Ӳ�̴�С
itemindex=1:itemno;%�������Ӧ�ı��

%% �㷨��������
maxIter=100;%����������
partical_size=100;%������
c1=2;
c2=2;
w=0.9;
minfitness=zeros(maxIter,1);

%% ��ʼ������
[particals] = initPartical(partical_size,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% ������Ӧ��
[particals,best_pos,best_fitness,best_no] = pso_cal_fitness(particals,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% ��ʼ����
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
    fprintf('��%d�ε�����ʹ����%d̨����\n',iter,best_no);
end
plot(1:maxIter,minfitness)
xlabel('��������')
ylabel('��Ӧ��ֵ')
fprintf('���Ž����£���ʹ����%d̨��������\n',best_no);
for k=1:best_no
    fprintf('���䵽��%d̨�����������Ϊ��',k);
    ss = find(best_pos==k);
    for kk=1:length(ss)
        fprintf('%d  ',ss(kk));
    end
    fprintf('\n');
end











