function [minfitness]=GGA(R_cpu,R_mem,R_hardDisk)
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
parentssize=floor(popsize*select_rate);%������Ⱥ��С
minfitness=zeros(maxIter,1);

%% ��ʼ����Ⱥ
[chromosome,BinNo] = GGA_initPoP(popsize,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% ������Ӧ��
fitnesses=GGA_cal_fitness(chromosome,BinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);

%% ��ʼ����
for iter=1:maxIter
    %% ��Ԫ����ѡ��
    [parents,parentsBinNo,indices] = GGA_select(chromosome,parentssize,fitnesses,BinNo);
    %% ����
    [offspring,OffBinNo]=GGA_crossover(parents,parentssize,parentsBinNo,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk);
    %% ����
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
%     fprintf('��%d�ε�����ʹ����%d̨����\n',iter,BinNo(idx));
end
% plot(1:maxIter,minfitness)
% xlabel('��������')
% ylabel('��Ӧ��ֵ')
% [~,colu]=size(chromosome);
% fprintf('���Ž����£���ʹ����%d̨��������\n',BinNo(idx));
% for k=1:colu
%     if ~isempty(chromosome{1,k})
%         fprintf('���䵽��%d̨�����������Ϊ��',k);
%         ss = chromosome{1,k};
%         for kk=1:length(ss)
%             fprintf('%d  ',ss(kk));
%         end
%         fprintf('\n');
%     end
% end

