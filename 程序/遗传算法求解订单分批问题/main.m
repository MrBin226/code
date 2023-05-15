clc;
clear;
close all;

%% ģ������
data=xlsread('data.xlsx');
coordinate=data(:,2:4);%������ŵ�����
volume=data(:,5).*data(:,6);%������ŵ����������*��λ���
max_volume=20000;%��ת������ݻ�
origin_coordinate=[0,0,0];%��ʼ����ֹ�������
a=1.5;%ͨ�����
b=1;%������
c=0.1;%ÿ�����ܿ�
d=1;%��λ��
cusnum=size(coordinate,1);%ȫ����ȡ�����������
[dist,origin_dis] = cal_distance(coordinate,origin_coordinate,a,b,c,d);%dist����������֮��ľ��룬origin_dis����ʼ�㵽ÿһ������ľ���

%% �Ŵ��㷨����
alpha=10;                                                       %Υ��������Լ���ĳͷ�����ϵ��
NIND=50;                                                        %��Ⱥ��С
MAXGEN=100;                                                     %��������
Pc=0.9;                                                         %�������
Pm=0.05;                                                        %�������
GGAP=0.9;                                                       %����(Generation gap)
N=cusnum+cusnum-1;                                               %Ⱦɫ�峤��=����������Ʒ��Ŀ+����ѡ·����Ŀ-1

%% ��Ⱥ��ʼ��
Chrom=InitPop(NIND,N);
disp('��ʼ��Ⱥ�е�һ�����ֵ:')
[currVC,NV,TD,violate_num,violate_cus]=decode(Chrom(1,:),cusnum,max_volume,volume,dist,origin_dis);       %�Գ�ʼ�����
disp(['��ѡ·����Ŀ��',num2str(NV),'����ѡ�ܾ��룺',num2str(TD)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% �Ż�
BestCost=zeros(MAXGEN,1);       %��¼ÿһ��ȫ�����Ž�
gen=1;
while gen<=MAXGEN
    %% ������Ӧ��
    ObjV=calObj(Chrom,cusnum,max_volume,volume,dist,origin_dis,alpha);                           %������ȺĿ�꺯��ֵ
    FitnV=Fitness(ObjV);
    %% ѡ��
    SelCh=Select(Chrom,FitnV,GGAP);
    %% OX�������
    SelCh=Recombin(SelCh,Pc);
    %% ����
    SelCh=Mutate(SelCh,Pm);
    %% �ֲ���������
    SelCh=LocalSearch(SelCh,cusnum,max_volume,volume,dist,origin_dis,alpha);
    %% �ز����Ӵ�������Ⱥ
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
    Chrom=deal_Repeat(Chrom);
    %% ��ӡ��ǰ���Ž�
    ObjV=calObj(Chrom,cusnum,max_volume,volume,dist,origin_dis,alpha);                           %������ȺĿ�꺯��ֵ
    [minObjV,minInd]=min(ObjV);
    BestCost(gen)=minObjV;
    disp(['��',num2str(gen),'�����Ž�:'])
    [bestVC,bestNV,bestTD,best_vionum,best_viocus]=decode(Chrom(minInd(1),:),cusnum,max_volume,volume,dist,origin_dis);
    disp(['��ѡ·����Ŀ��',num2str(bestNV),'����ѡ�ܾ��룺',num2str(bestTD)]);
    fprintf('\n')
    %% ���µ�������
    gen=gen+1 ;
end
%% ��ӡ���ѭ��ÿ�ε�����ȫ�����Ž���ܳɱ��仯����ͼ
figure;
hold on
plot(BestCost,'LineWidth',1);
title('ȫ�����Ž�ľ���仯����ͼ')
xlabel('��������');
ylabel('��ѡ�ܾ���');
hold off
disp('ÿ����ѡ·���ļ�ѡ˳��������ʾ��')
for i=1:bestNV
    p_l= part_length(bestVC{i},dist,origin_dis);
    fprintf('��ѡ·��%d(����Ϊ%.2f)��',i,p_l);
    for j=1:length(bestVC{i})
        fprintf('%d  ',bestVC{i}(j));
    end
    fprintf('\n');
end
draw_Best(bestVC,coordinate,origin_coordinate);








