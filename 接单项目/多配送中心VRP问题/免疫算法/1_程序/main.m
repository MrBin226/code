%% �����Ż��㷨��������������ѡַ�е�Ӧ��
%% ��ջ���
close all
clc
clear

%% �㷨��������           
sizepop=50;           % ��Ⱥ��ģ
overbest=10;          % ���������
MAXGEN=100;            % ��������
pcross=0.5;           % �������
pmutation=0.3;        % �������
ps=0.95;              % ���������۲���
length=4;             % ����������
M=sizepop+overbest;

%% step1 ʶ��ԭ,����Ⱥ��Ϣ����Ϊһ���ṹ��
individuals = struct('fitness',zeros(1,M), 'concentration',zeros(1,M),'excellence',zeros(1,M),'chrom',[]);
%% step2 ������ʼ����Ⱥ
individuals.chrom = popinit(M,length);
trace=[]; %��¼ÿ�����������Ӧ�Ⱥ�ƽ����Ӧ��

%% ����Ѱ��
for iii=1:MAXGEN

     %% step3 ����Ⱥ����������
     for i=1:M
         individuals.fitness(i) = fitness(individuals.chrom(i,:));      % �����뿹ԭ�׺Ͷ�(��Ӧ��ֵ������
         individuals.concentration(i) = concentration(i,M,individuals); % ����Ũ�ȼ���
     end
     % �ۺ��׺ͶȺ�Ũ�����ۿ�������̶ȣ��ó���ֳ����
     individuals.excellence = excellence(individuals,M,ps);
          
     % ��¼������Ѹ������Ⱥƽ����Ӧ��
     [best,index] = min(individuals.fitness);   % �ҳ�������Ӧ�� 
     bestchrom = individuals.chrom(index,:);    % �ҳ����Ÿ���
     average = mean(individuals.fitness);       % ����ƽ����Ӧ��
     trace = [trace;best,average];              % ��¼
     
     %% step4 ����excellence���γɸ���Ⱥ�����¼���⣨���뾫Ӣ�������ԣ�����s���ƣ�
     bestindividuals = bestselect(individuals,M,overbest);   % ���¼����
     individuals = bestselect(individuals,M,sizepop);        % �γɸ���Ⱥ

     %% step5 ѡ�񣬽��棬����������ټ��������п��壬��������Ⱥ
     individuals = Select(individuals,sizepop);                                                             % ѡ��
     individuals.chrom = Cross(pcross,individuals.chrom,sizepop,length);                                    % ����
     individuals.chrom = Mutation(pmutation,individuals.chrom,sizepop,length);   % ����
     individuals = incorporate(individuals,sizepop,bestindividuals,overbest);                               % ���������п���      

end

%% ���������㷨��������
figure(1)
plot(trace(:,1));
hold on
plot(trace(:,2),'--');
legend('������Ӧ��ֵ','ƽ����Ӧ��ֵ')
title('�����㷨��������','fontsize',12)
xlabel('��������','fontsize',12)
ylabel('��Ӧ��ֵ','fontsize',12)
%���ѡַ���
disp(bestchrom);
%���ѡַ�ɱ�
fprintf('���ųɱ���%f\n',trace(end,1))
[~,cost]=fitness(bestchrom);
disp(cost);
% disp(fit,cost);


% [x,y] = fitness_end(bestchrom);
