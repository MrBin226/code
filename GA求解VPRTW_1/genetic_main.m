clear;
clc;
close all;
TC1 = 300; %�����̶��ɱ�
TC2 = 1.2; %����ɱ�
len = 500; %����������о���
c1 = 90 / 60; %ÿ���ӵĳͷ��ɱ�
Vk = 45;%�ٶ�
cap=3000;%�������װ����
data = xlsread('����.xlsx');
h=pdist(data(:,2:3));
dist=squareform(h); 
transport_time = dist * 60 / Vk;

E=data(1,5);%��������ʱ�䴰��ʼʱ��
L=data(1,6);%��������ʱ�䴰����ʱ��
customers_demand =data(2:end,[1,4]); % ������
customers_time = data(2:end,5:6); % ʱ�䴰Լ��
service_time = data(2:end, 7);%����ʱ��
customer = [customers_demand,customers_time,service_time];   %�ͻ��Ļ�����Ϣ
cusnum = size(customer, 1);
v_num=cusnum;   %�������ʹ����Ŀ

NIND=100;    %��Ⱥ��С
MAXGEN=500;   %��������
Pc=0.9;       %�������
Pm=0.01;     %�������
N=cusnum+v_num-1; %Ⱦɫ�峤��=�˿���Ŀ+�������ʹ����Ŀ-1
fitness = zeros(MAXGEN, 1);
%% ��ʼ����Ⱥ
Chrom=InitPopCW(NIND,N,cusnum,customers_time,customers_demand,cap,len,dist);

%% ����Ŀ�꺯��ֵ
ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len);

%% 
Generation=1;
while Generation <= MAXGEN
    %% ѡ��
    SelCh = Select(Chrom,ObjV);
    %% OX�������
    SelCh=Recombin(SelCh,Pc);
    %% ����
    SelCh=Mutate(SelCh,Pm);
    %% �ֲ���������
    SelCh=LocalSearch(SelCh,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len);
    %% ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
    SelCh=deal_Repeat(SelCh);
    %% ɸѡ����һ���Ӵ�
    Chrom = [Chrom;SelCh];
    ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len);
    [ObjV1,idx]=sort(ObjV);
    Chrom = Chrom(idx,:);
    Chrom = Chrom(1:NIND,:);
    fprintf('��%d�ε���\n',Generation);
    fitness(Generation) = ObjV1(1);
    ObjV = ObjV1(1:NIND);
    Generation = Generation+1;
end
figure(1)
plot(1:MAXGEN, fitness);
ylabel('�ɱ�');
xlabel('��������');
title('��������');

demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
saveas(gcf,'��������ͼ.png');
[VC,NV,~,violate_num,~]=decode(Chrom(1,:),cusnum,cap,demands,a,b,L,s,dist,len);
fprintf('�ܳɱ�Ϊ��%.2f,��ʹ����%d����\n',ObjV(1),NV);
draw_Best(VC,data(:,2:3));
