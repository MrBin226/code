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
% 初始化参数
m = 80; %蚂蚁数量，其数量大约为城市数量的1.5倍
alpha = 1; % 信息素重要程序因子，一般取[1,4]
beta = 5; % 启发函数重要程序因子
vol = 0.2; % 信息素挥发因子
Q = 10; % 信息素总量
Heu_F = 1./dist; % 启发函数值
Tau = ones(city_num,city_num); %信息素矩阵
Table = zeros(m,city_num); %每只蚂蚁走过的路径记录表
iter_max=100;%最大迭代次数
Route_best=zeros(iter_max,city_num);%最优路径
length_best=zeros(1,iter_max);%最优路径值
length_ave=zeros(1,iter_max);%各代蚂蚁路径的平均长度
limit_iter=0;%收敛时的迭代次数
for iter=1:iter_max
    % 随机产生每只蚂蚁的初始出发点
    Table(:,1)=randi(city_num,m,1);
    % 所有的城市点
    city_index=1:city_num;
    Length=zeros(1,m);
    for i=1:m
        for j=2:city_num
            tabu=Table(i,1:j-1);%已访问的城市集合
            allow_index=~ismember(city_index,tabu);%未访问的城市索引
            allow = city_index(allow_index);%未访问的城市
            P = zeros(1,length(allow)); %城市j-1到未访问的城市的各个概率
            for k=1:length(allow)
                P(k)=Tau(tabu(end),allow(k))^alpha * Heu_F(tabu(end),allow(k))^beta;
            end
            P = P / sum(P);
            % 采用轮盘赌选择法选择下一个城市
            Pc=cumsum(P);%累积概率
            target_index=find(Pc>=rand());
            Table(i,j)=allow(target_index(1));
        end
        Length(i)=cal_distance(Table(i,:),dist);
    end
    [length_best(iter),idx]=min(Length);
    Route_best(iter,:)=Table(idx,:);
    length_ave(iter)=mean(Length);
    % 更新信息素
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
% legend('最优适应度','平均适应度')
% hold off
% disp('最优解为：');
% disp(length_best(end));
figure(2)
drawBest(data,Route_best(end,:),city_num)
[~,tt]=find(Route_best(end,:)==1);
rout=[Route_best(end,tt:end),Route_best(end,1:tt-1)];
jie_zhyy1=cell(1,size(data,1)+1);
disp('最优的清扫路线：');
for i=1:size(data,1)
    fprintf('%d->',rout(i));
    jie_zhyy1{i}=h(rout(i),:);
end
jie_zhyy1{end}=h(1,:);
fprintf('%d',1);
fprintf('\n');
fprintf('长度=%d\n',length_best(end));



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