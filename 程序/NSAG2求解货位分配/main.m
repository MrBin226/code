clc;
clear;
close all;

%% ģ�Ͳ���
shelve_data=importdata('data.txt');%��λ����
shelve_num=size(shelve_data,1);%��λ����
layer=shelve_data(:,3);%��λ���ڲ���
commodity_num=15;%��Ʒ����
order_data=importfile('order_data.txt',',');%��������
warehouse=struct();%�ֿ���ز���
warehouse.v_c=1.5;%���󳵵��ٶ�
warehouse.v_s=1.5;%���������ٶ�
warehouse.a_c=1;%���󳵵ļ��ٶ�
warehouse.a_s=1;%�������ļ��ٶ�
warehouse.l=1.5;%��λ����
warehouse.h=2;%���ܵĸ߶�
warehouse.t_t=1;%���󳵵Ļ���ʱ��
warehouse.t_p=1;%���󳵵�װ��ж��ʱ��
warehouse.t_sc=1;%�������봩�󳵵Ľ���ʱ��

%% �㷨����
pop_size=25;%��Ⱥ����
chrome_length=commodity_num;%Ⱦɫ�峤��
MAX_Iter=100;%����������
Pc=0.8;%�������
Pm=0.1;%�������

%% ��ʼ����Ⱥ
[pop] = initPoP(pop_size,chrome_length,shelve_num);

%% ����Ŀ��ֵ
[fitness] = cal_fitness(pop,layer,shelve_data,warehouse,order_data);

%% ��֧������
FrontValue = NonDominateSort(fitness,0); 
CrowdDistance = CrowdDistances(fitness,FrontValue);%����ۼ�����

%% ��ʼ����
Generation=1;
while Generation <= MAX_Iter
    %% ѡ��
    SelCh = Mating(pop,FrontValue,CrowdDistance); %�����ѡ��2�Ľ�����ѡ��ʽ
    %% OX�������
    SelCh=Recombin(SelCh,Pc);
    %% ����
    SelCh=Mutate(SelCh,Pm);
    %% ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
    SelCh=deal_Repeat(SelCh,shelve_num);
    %% ɸѡ����һ���Ӵ�
    pop = [pop;SelCh];
    [fitness] = cal_fitness(pop,layer,shelve_data,warehouse,order_data);
    [FrontValue,MaxFront] = NonDominateSort(fitness,0); 
    CrowdDistance = CrowdDistances(fitness,FrontValue);%����ۼ�����
    
    %ѡ����֧��ĸ���        
    Next = zeros(1,pop_size);
    N_con = 0;
    t=1;
    for k=1:MaxFront
        if (N_con + length(find(FrontValue==k)))<=pop_size
            N_con = N_con+length(find(FrontValue==k));
            Next(t:N_con) = find(FrontValue==k);
            t = N_con+1;
        else
            break;
        end
    end
    if ismember(0,Next)
        Last = find(FrontValue==k);
        [~,Rank] = sort(CrowdDistance(Last),'descend');
        Next(t:pop_size) = Last(Rank(1:pop_size-t+1));
    end
     %��һ����Ⱥ
    pop = pop(Next,:);
    FrontValue = FrontValue(Next);
    CrowdDistance = CrowdDistance(Next);

    [fitness] = cal_fitness(pop,layer,shelve_data,warehouse,order_data);
    fprintf('��%d�ε���\n',Generation);
    Generation = Generation+1;
end
fid = fopen('result.txt','w');
n_o = find(FrontValue==1);
disp('�����н����£�');
for i=1:length(n_o)
    fprintf(fid,'��%d���⣬Ŀ��ֵ1Ϊ��%.2f��Ŀ��ֵ2Ϊ��%.2f\n',i,fitness(n_o(i),1),fitness(n_o(i),2));
    for j=1:chrome_length
        fprintf(fid,'%d->(%d,%d,%d)\n ',j,shelve_data(pop(n_o(i),j),1),shelve_data(pop(n_o(i),j),2),shelve_data(pop(n_o(i),j),3));
    end
end
fclose(fid);
figure(1)
scatter(fitness(n_o,1),fitness(n_o,2),'filled');
ylabel('���󳵹�����ƽ��');
xlabel('����ʱ��');
title('���������Ž�');







