clc;
clear;
close all;
data=[1 1 1;2 1 3;3 1 5;4 1 7;...
      5 3 1;6 3 3;7 3 5;8 3 7;...
      9 5 1;10 5 3;11 5 5;12 5 7;...
      13 7 1;14 7 3;15 7 5;16 7 7]; 
h=data(:,2:3);
dist=zeros(size(data,1));
for i=1:size(data,1)-1
    for j=i+1:size(data,1)
        dist(i,j)=abs(h(i,1)-h(j,1))+abs(h(i,2)-h(j,2));
        dist(j,i)=abs(h(i,1)-h(j,1))+abs(h(i,2)-h(j,2));
    end
end
city_num=size(data,1);
% ��ʼ������
m = 80; %������������������ԼΪ����������1.5��
alpha = 1; % ��Ϣ����Ҫ�������ӣ�һ��ȡ[1,4]
beta = 5; % ����������Ҫ��������
vol = 0.2; % ��Ϣ�ػӷ�����
Q = 10; % ��Ϣ������
Heu_F = 1./dist; % ��������ֵ
Tau = ones(city_num,city_num); %��Ϣ�ؾ���
Table = zeros(m,city_num); %ÿֻ�����߹���·����¼��
iter_max=100;%����������
Route_best=zeros(iter_max,city_num);%����·��
length_best=zeros(1,iter_max);%����·��ֵ
length_ave=zeros(1,iter_max);%��������·����ƽ������
limit_iter=0;%����ʱ�ĵ�������
for iter=1:iter_max
    % �������ÿֻ���ϵĳ�ʼ������
    Table(:,1)=randi(city_num,m,1);
    % ���еĳ��е�
    city_index=1:city_num;
    Length=zeros(1,m);
    for i=1:m
        for j=2:city_num
            tabu=Table(i,1:j-1);%�ѷ��ʵĳ��м���
            allow_index=~ismember(city_index,tabu);%δ���ʵĳ�������
            allow = city_index(allow_index);%δ���ʵĳ���
            P = zeros(1,length(allow)); %����j-1��δ���ʵĳ��еĸ�������
            for k=1:length(allow)
                P(k)=Tau(tabu(end),allow(k))^alpha * Heu_F(tabu(end),allow(k))^beta;
            end
            P = P / sum(P);
            % �������̶�ѡ��ѡ����һ������
            Pc=cumsum(P);%�ۻ�����
            target_index=find(Pc>=rand());
            Table(i,j)=allow(target_index(1));
        end
        Length(i)=cal_distance(Table(i,:),dist);
    end
    [length_best(iter),idx]=min(Length);
    Route_best(iter,:)=Table(idx,:);
    length_ave(iter)=mean(Length);
    % ������Ϣ��
    Delta_tau = zeros(city_num,city_num);
    for i=1:m
        for j=1:city_num-1
            Delta_tau(Table(i,j),Table(i,j+1))=Delta_tau(Table(i,j),Table(i,j+1))+Q/Length(i);
        end
        Delta_tau(Table(i,city_num),Table(i,1))=Delta_tau(Table(i,city_num),Table(i,1))+Q/Length(i);
    end
    Tau=(1-vol)*Tau+Delta_tau;
    Table = zeros(m,city_num);
end
% figure(1)
% hold on
% plot(1:iter,length_best)
% plot(1:iter,length_ave)
% legend('������Ӧ��','ƽ����Ӧ��')
% hold off
% disp('���Ž�Ϊ��');
% disp(length_best(end));
figure(2)
drawBest(data,Route_best(end,:),city_num)
[~,tt]=find(Route_best(end,:)==1);
rout=[Route_best(end,tt:end),Route_best(end,1:tt-1)];
jie_zhyy1=cell(1,size(data,1)+1);
disp('���ŵ���ɨ·�ߣ�');
for i=1:size(data,1)
    fprintf('%d->',rout(i));
    jie_zhyy1{i}=h(rout(i),:);
end
jie_zhyy1{end}=h(1,:);
fprintf('%d',1);
fprintf('\n');
fprintf('����=%d\n',length_best(end));



function [dis]=cal_distance(city_order,dist)
dis=0;
N=length(city_order);
for k=1:N-1
    dis=dis+dist(city_order(k),city_order(k+1));
end
dis=dis+dist(city_order(end),city_order(1));
end

function drawBest(data,sol_best,city_num)
hold on
scatter(data(:,2),data(:,3),'filled')
for i=1:city_num-1
    line([data(sol_best(i),2),data(sol_best(i+1),2)],[data(sol_best(i),3),data(sol_best(i+1),3)])
end
line([data(sol_best(end),2),data(sol_best(1),2)],[data(sol_best(end),3),data(sol_best(1),3)])
hold off
end