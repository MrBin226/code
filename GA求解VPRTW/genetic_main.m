clear;
clc;
close all;
C1k = 0.5;
C2k = 50;
a1 = 0.1;
a2 = 0.5;
a3 = 0.2;
Vk = 50;
cap=300;%�������װ����
data = xlsread('5-�ڶ���-��.xlsx');
% data = xlsread('����.xlsx');
h=pdist(data(:,2:3));
dist=squareform(h); 
transport_time = dist / Vk;

E=data(1,5);%��������ʱ�䴰��ʼʱ��
L=data(1,6);%��������ʱ�䴰����ʱ��
customers_demand =data(2:end,[1,4]); % ������
customers_time = data(2:end,5:6); % ʱ�䴰Լ��
service_time = data(2:end, 7);%����ʱ��
customer = [customers_demand,customers_time,service_time];   %�ͻ��Ļ�����Ϣ
cusnum = size(customer, 1);
v_num=cusnum;   %�������ʹ����Ŀ

NIND=50;    %��Ⱥ��С
MAXGEN=100;   %��������
Pc=0.9;       %�������
Pm=0.05;     %�������
N=cusnum+v_num-1; %Ⱦɫ�峤��=�˿���Ŀ+�������ʹ����Ŀ-1
%% ��ʼ����Ⱥ
Chrom=InitPopCW(NIND,N,cusnum,customers_time,customers_demand,cap);

%% ����Ŀ�꺯��ֵ
ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);

%% ��֧������
FrontValue = NonDominateSort(ObjV,0); 
CrowdDistance = CrowdDistances(ObjV,FrontValue);%����ۼ�����
%% 
Generation=1;
while Generation <= MAXGEN
    %% ѡ��
    SelCh = Mating(Chrom,FrontValue,CrowdDistance); %�����ѡ��2�Ľ�����ѡ��ʽ
    %% OX�������
    SelCh=Recombin(SelCh,Pc);
    %% ����
    SelCh=Mutate(SelCh,Pm);
    %% �ֲ���������
    SelCh=LocalSearch(SelCh,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);
    %% ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
    SelCh=deal_Repeat(SelCh);
    %% ɸѡ����һ���Ӵ�
    Chrom = [Chrom;SelCh];
    ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);
    [FrontValue,MaxFront] = NonDominateSort(ObjV,0); 
    CrowdDistance = CrowdDistances(ObjV,FrontValue);%����ۼ�����
    
    %ѡ����֧��ĸ���        
    Next = zeros(1,NIND);
    N_con = 0;
    t=1;
    for k=1:MaxFront
        if (N_con + length(find(FrontValue==k)))<=NIND
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
        Next(t:NIND) = Last(Rank(1:NIND-t+1));
    end
     %��һ����Ⱥ
    Chrom = Chrom(Next,:);
    FrontValue = FrontValue(Next);
    CrowdDistance = CrowdDistance(Next);

    ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time);
    fprintf('��%d�ε���\n',Generation);
    Generation = Generation+1;
end
figure(1)
scatter(ObjV(:,2),ObjV(:,1),'filled');
ylabel('�ɱ�');
xlabel('�˿������');
title('���������Ž�');
n_o = find(FrontValue==1);
demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
[c1,c2] = sortrows(ObjV);
fprintf('�ɱ���%f,����ȣ�%f\n',c1(1,1),c1(1,2));
[VC,NV,~,violate_num,~]=decode(Chrom(c2(1),:),cusnum,cap,demands,a,b,L,s,dist);
draw_Best(VC,data(:,2:3));
