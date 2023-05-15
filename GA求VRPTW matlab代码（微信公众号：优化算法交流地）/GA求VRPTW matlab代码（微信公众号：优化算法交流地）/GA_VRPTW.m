%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
clear
clc
close all
tic
%% ��importdata�����������ȡ�ļ�
c101=importdata('c101.txt');
cap=200;                                                        %�������װ����
%% ��ȡ������Ϣ
E=c101(1,5);                                                    %��������ʱ�䴰��ʼʱ��
L=c101(1,6);                                                    %��������ʱ�䴰����ʱ��
vertexs=c101(:,2:3);                                            %���е������x��y
customer=vertexs(2:end,:);                                       %�˿�����
cusnum=size(customer,1);                                         %�˿���
v_num=25;                                                        %�������ʹ����Ŀ
demands=c101(2:end,4);                                          %������
a=c101(2:end,5);                                                %�˿�ʱ�䴰��ʼʱ��[a[i],b[i]]
b=c101(2:end,6);                                                %�˿�ʱ�䴰����ʱ��[a[i],b[i]]
s=c101(2:end,7);                                                %�ͻ���ķ���ʱ��
h=pdist(vertexs);
dist=squareform(h);                                             %��������������ǹ�ϵ�����þ����ʾ����c[i][j]=dist[i][j]
%% �Ŵ��㷨��������
alpha=10;                                                       %Υ��������Լ���ĳͷ�����ϵ��
belta=100;                                                      %Υ��ʱ�䴰Լ���ĳͷ�����ϵ��
NIND=100;                                                       %��Ⱥ��С
MAXGEN=100;                                                     %��������
Pc=0.9;                                                         %�������
Pm=0.05;                                                        %�������
GGAP=0.9;                                                       %����(Generation gap)
N=cusnum+v_num-1;                                               %Ⱦɫ�峤��=�˿���Ŀ+�������ʹ����Ŀ-1
%% ��ʼ����Ⱥ
init_vc=init(cusnum,a,demands,cap);                             %�����ʼ��
Chrom=InitPopCW(NIND,N,cusnum,init_vc);
%% ���������·�ߺ��ܾ���
disp('��ʼ��Ⱥ�е�һ�����ֵ:')
[VC,NV,TD,violate_num,violate_cus]=decode(Chrom(1,:),cusnum,cap,demands,a,b,L,s,dist);
% disp(['�ܾ��룺',num2str(TD)]);
disp(['����ʹ����Ŀ��',num2str(NV),'��������ʻ�ܾ��룺',num2str(TD),'��Υ��Լ��·����Ŀ��',num2str(violate_num),'��Υ��Լ���˿���Ŀ��',num2str(violate_cus)]);
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
%% �Ż�
gen=1;
figure;
hold on;box on
xlim([0,MAXGEN])
title('�Ż�����')
xlabel('����')
ylabel('����ֵ')
ObjV=calObj(Chrom,cusnum,cap,demands,a,b,L,s,dist,alpha,belta);             %������ȺĿ�꺯��ֵ
preObjV=min(ObjV);
while gen<=MAXGEN
    %% ������Ӧ��
    ObjV=calObj(Chrom,cusnum,cap,demands,a,b,L,s,dist,alpha,belta);             %������ȺĿ�꺯��ֵ
    line([gen-1,gen],[preObjV,min(ObjV)]);pause(0.0001)
    preObjV=min(ObjV);
    FitnV=Fitness(ObjV);
    %% ѡ��
    SelCh=Select(Chrom,FitnV,GGAP);
    %% OX�������
    SelCh=Recombin(SelCh,Pc);
    %% ����
    SelCh=Mutate(SelCh,Pm);
    %% �ֲ���������
    SelCh=LocalSearch(SelCh,cusnum,cap,demands,a,b,L,s,dist,alpha,belta);
    %% �ز����Ӵ�������Ⱥ
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
    Chrom=deal_Repeat(Chrom);
    %% ��ӡ��ǰ���Ž�
    ObjV=calObj(Chrom,cusnum,cap,demands,a,b,L,s,dist,alpha,belta);             %������ȺĿ�꺯��ֵ
    [minObjV,minInd]=min(ObjV);
    disp(['��',num2str(gen),'�����Ž�:'])
    [bestVC,bestNV,bestTD,best_vionum,best_viocus]=decode(Chrom(minInd(1),:),cusnum,cap,demands,a,b,L,s,dist);
    disp(['����ʹ����Ŀ��',num2str(bestNV),'��������ʻ�ܾ��룺',num2str(bestTD),'��Υ��Լ��·����Ŀ��',num2str(best_vionum),'��Υ��Լ���˿���Ŀ��',num2str(best_viocus)]);
    fprintf('\n')
    %% ���µ�������
    gen=gen+1 ;
end
%% �������Ž��·��ͼ
ObjV=calObj(Chrom,cusnum,cap,demands,a,b,L,s,dist,alpha,belta);             %������ȺĿ�꺯��ֵ
[minObjV,minInd]=min(ObjV);
%% ������Ž��·�ߺ��ܾ���
disp('���Ž�:')
bestChrom=Chrom(minInd(1),:);
[bestVC,bestNV,bestTD,best_vionum,best_viocus]=decode(bestChrom,cusnum,cap,demands,a,b,L,s,dist);
disp(['����ʹ����Ŀ��',num2str(bestNV),'��������ʻ�ܾ��룺',num2str(bestTD),'��Υ��Լ��·����Ŀ��',num2str(best_vionum),'��Υ��Լ���˿���Ŀ��',num2str(best_viocus)]);
disp('-------------------------------------------------------------')
%% �ж����Ž��Ƿ�����ʱ�䴰Լ����������Լ����0��ʾΥ��Լ����1��ʾ����ȫ��Լ��
flag=Judge(bestVC,cap,demands,a,b,L,s,dist);
%% ������Ž����Ƿ����Ԫ�ض�ʧ���������ʧԪ�أ����û����Ϊ��
DEL=Judge_Del(bestVC);
%% ��������·��ͼ
draw_Best(bestVC,vertexs);
save c101.mat
toc