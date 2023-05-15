clear;clc;close all;
%% ģ�Ͳ�������
LT2=3;
C5=200;
Y1=4;
DS=2;
LT1=LT2*DS;
T=30;
C6=0.2;
P2=22;
flag=input('������flag��flag=1��ʾ����r<LT1;flag=0��ʾ����r>=LT1)��'); % ��������ǣ�flag=1��ʾ����r<LT1;flag=0��ʾ����r>=LT1;

%% �Ŵ���������
NUMPOP=50;%��ʼ��Ⱥ��С
if flag
    % r<LT1
    % �ж�LT1�Ƿ�ΪС��
    if floor(LT1)==LT1
        r_min=1; %���������
        r_max=floor(LT1)-1;
    else
        r_min=1; %���������
        r_max=floor(LT1);
    end
else
    % r>=LT1
    r_min=ceil(LT1); %���������
    r_max=3*ceil(LT1);%Ϊ�˼��㷽�㣬Ҳ��r�趨һ������
end
q_min=1;
q_max=100;
%����һ������x��ȡֵ��ΧΪ[a,b]������Ϊe����ת��Ϊ�����Ʊ�����������Ⱦɫ�峤�ȼ��㹫ʽΪlog2((b-a)/e  + 1)
r_l = ceil(log2(r_max-r_min+1)); %����r�����Ⱦɫ�峤��
q_l = ceil(log2(q_max-q_min+1));
LENGTH=[r_l,q_l]; %�����Ʊ��볤��
ITERATION = 500;%��������
CROSSOVERRATE = 0.9;%�ӽ���
SELECTRATE = 0.5;%ѡ����
VARIATIONRATE = 0.05;%������

%% ��ʼ����Ⱥ
pop=m_InitPop(NUMPOP,r_min,r_max,q_min,q_max);

%% ��ʼ����
for time=1:ITERATION
    if flag
        fprintf('==========����������%d(r<LT1)=========\n',time);
    else
        fprintf('==========����������%d(r>=LT1)=========\n',time);
    end
    %�����ʼ��Ⱥ����Ӧ��
    fitness=m_Fitness(pop,LT1,C5,Y1,DS,T,C6,P2);
    %ѡ��
    pop=m_Select(fitness,pop,SELECTRATE);
    %����
    binpop=m_Coding(pop,LENGTH,r_min,r_max,q_min,q_max);
    %����
    kidsPop = crossover(binpop,NUMPOP,CROSSOVERRATE,LENGTH);
    %����
    kidsPop = Variation(kidsPop,VARIATIONRATE,LENGTH);
    %����
    kidsPop=m_Incoding(kidsPop,r_min,r_max,q_min,q_max,LENGTH);
    %������Ⱥ
    pop=[pop kidsPop];
    fitness=m_Fitness(pop,LT1,C5,Y1,DS,T,C6,P2);
    [f,idx]=min(fitness);
    fprintf('������=%d��',pop(1,idx));
    fprintf('������=%d��',pop(2,idx));
    fprintf('�ܿ�����=%.2f\n',f);
    iter_fit(time)=f;
end

figure
hold on
box on
title('�����仯����');
plot(iter_fit);
xlabel('��������');
ylabel('�ܿ�����');
hold off
    


