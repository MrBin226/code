tic
clear
clc
%% ��importdata�����������ȡ�ļ� 
data=importdata('rc208.txt');
cap=1000;
%% ��ȡ������Ϣ
vertexs=data(:,2:3);                %���е������x��y
customer=vertexs(2:end,:);          %�˿�����
cusnum=size(customer,1);            %�˿���
v_num=25;                           %��ʼ����ʹ����Ŀ
demands=data(2:end,4);              %������
h=pdist(vertexs);
dist=squareform(h);                 %�������
%% �Ŵ��㷨��������
alpha=10;                                                       %Υ��������Լ���ĳͷ�����ϵ��
NIND=50;                                                        %��Ⱥ��С
MAXGEN=30;                                                     %��������
Pc=0.9;                                                         %�������
Pm=0.05;                                                        %�������
GGAP=0.9;                                                       %����(Generation gap)
N=cusnum+v_num-1;                                               %Ⱦɫ�峤��=�˿���Ŀ+�������ʹ����Ŀ-1
%% ��Ⱥ��ʼ��
Chrom=InitPop(NIND,N);
%% ���������·�ߺ��ܾ���
disp('��ʼ��Ⱥ�е�һ�����ֵ:')
[currVC,NV,TD,violate_num,violate_cus]=decode(Chrom(1,:),cusnum,cap,demands,dist);       %�Գ�ʼ�����
currCost=costFuction(currVC,dist,demands,cap,alpha);        %���ʼ���ͷ����ĳɱ�=������ʻ�ܳɱ�+alpha*Υ��������Լ��֮��
disp(['����ʹ����Ŀ��',num2str(NV),'��������ʻ�ܾ��룺',num2str(TD),'��Υ��Լ��·����Ŀ��',num2str(violate_num),'��Υ��Լ���˿���Ŀ��',num2str(violate_cus)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% �Ż�
BestCost=zeros(MAXGEN,1);       %��¼ÿһ��ȫ�����Ž���ܳɱ�
gen=1;
while gen<=MAXGEN
    %% ������Ӧ��
    ObjV=calObj(Chrom,cusnum,cap,demands,dist,alpha);                           %������ȺĿ�꺯��ֵ
    FitnV=Fitness(ObjV);
    %% ѡ��
    SelCh=Select(Chrom,FitnV,GGAP);
    %% OX�������
    SelCh=Recombin(SelCh,Pc);
    %% ����
    SelCh=Mutate(SelCh,Pm);
    %% �ֲ���������
    SelCh=LocalSearch(SelCh,cusnum,cap,demands,dist,alpha);
    %% �ز����Ӵ�������Ⱥ
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
    Chrom=deal_Repeat(Chrom);
    %% ��ӡ��ǰ���Ž�
    ObjV=calObj(Chrom,cusnum,cap,demands,dist,alpha);                           %������ȺĿ�꺯��ֵ
    [minObjV,minInd]=min(ObjV);
    BestCost(gen)=minObjV;
    disp(['��',num2str(gen),'�����Ž�:'])
    [bestVC,bestNV,bestTD,best_vionum,best_viocus]=decode(Chrom(minInd(1),:),cusnum,cap,demands,dist);
    disp(['����ʹ����Ŀ��',num2str(bestNV),'��������ʻ�ܾ��룺',num2str(bestTD),'��Υ��Լ��·����Ŀ��',num2str(best_vionum),'��Υ��Լ���˿���Ŀ��',num2str(best_viocus)]);
    fprintf('\n')
    %% ���µ�������
    gen=gen+1 ;
end
%% ��ӡ���ѭ��ÿ�ε�����ȫ�����Ž���ܳɱ��仯����ͼ
figure;
plot(BestCost,'LineWidth',1);
title('ȫ�����Ž���ܳɱ��仯����ͼ')
xlabel('��������');
ylabel('�ܳɱ�');
%% ��ӡȫ�����Ž�·��ͼ
draw_Best(bestVC,vertexs);
toc