function [minfitness]=GA(R_cpu,R_mem,R_hardDisk)
%% ģ�Ͳ�������
binsize=100;%������
itemno=250;%���������
% R_cpu_set=[0.25,0.5,1,1.5,2,2.5,3,4];%�����cpu���󼯺�
% R_mem_set=[0.25,0.5,1,1.5,2,2.5,3,4];%������ڴ����󼯺�
% R_cpu=randsample(R_cpu_set,itemno,1);%ÿ���������Ӧ��cpu�����С
% R_mem=randsample(R_mem_set,itemno,1);%ÿ���������Ӧ���ڴ������С
C_cpu=8;%ÿ��������Ӧ��cpu��С
C_mem=8;%ÿ��������Ӧ���ڴ��С
C_hardDisk=8;%ÿ��������Ӧ��Ӳ�̴�С
itemindex=1:itemno;%�������Ӧ�ı��

%% �㷨��������
maxIter=100;%����������
popsize=100;%��Ⱥ��С
select_rate=0.8;%ѡ�����
mutratio=0.3;%�������
minfitness=zeros(maxIter,1);

%% ��ʼ����Ⱥ
[chromosome,BinNo] = initPoP(popsize,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% ������Ӧ��
fitness=cal_fitness(chromosome,BinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% ��ʼ����
for iter=1:maxIter
    %% ��Ԫ����ѡ��
    [parents,parentsBinNo,indices] = select(chromosome,select_rate,fitness,BinNo);
    %% ����
    [children,offeringNo] = crossover(parents,parentsBinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    %% ����
    [new_children,mutionNo] = mution(children,offeringNo,mutratio,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    %% ѡ����һ������
    new_fit=cal_fitness(new_children,mutionNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    all_pop=[chromosome;new_children];
    all_fit=[fitness;new_fit];
    all_no=[BinNo;mutionNo];
    [~,idx]=sort(all_fit);
    chromosome=all_pop(idx(1:popsize),:);
    BinNo=all_no(idx(1:popsize));
    fitness=all_fit(idx(1:popsize));
    minfitness(iter)=fitness(1);
%     fprintf('��%d�ε�����ʹ����%d̨����\n',iter,BinNo(1));
end
% save f1.mat minfitness
% plot(1:maxIter,minfitness)
% xlabel('��������')
% ylabel('��Ӧ��ֵ')
% [~,colu]=size(chromosome);
% fprintf('���Ž����£���ʹ����%d̨��������\n',BinNo(1));
% for k=1:BinNo(1)
%     fprintf('���䵽��%d̨�����������Ϊ��',k);
%     ss = find(chromosome(1,:)==k);
%     for kk=1:length(ss)
%         fprintf('%d  ',ss(kk));
%     end
%     fprintf('\n');
% end












