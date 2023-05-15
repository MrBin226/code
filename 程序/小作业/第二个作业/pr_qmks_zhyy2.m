clc;
clear;
close all;
data=[1 0.5 0.5;2 0.5 2.5;3 0.5 4.5;4 0.5 6.5;...
      5 2.5 0.5;6 2.5 2.5;7 2.5 4.5;8 2.5 6.5;...
      9 4.5 0.5;10 4.5 2.5;11 4.5 4.5;12 4.5 6.5;...
      13 6.5 0.5;14 6.5 2.5;15 6.5 4.5;16 6.5 6.5]; 
h=data(:,2:3);
pos=1:4;% A,B,C,D
city_num=size(data,1);
sol_new1=randperm(city_num);%每次产生的新解
sol_new2=arrayfun(@(x) pos(unidrnd(4)),1:city_num);
sol_current1=sol_new1;%当前解
sol_current2=sol_new2;%当前解
sol_best1=sol_new1;%最好的解
sol_best2=sol_new2;%最好的解
E_new=cal_distance(sol_new1,sol_new2,h);
E_current=E_new;
E_best=E_new;
T0=1000;%初始温度
Tf=2;%终止温度
T=T0;%当前温度
Markov_length=1000;%马尔可夫链的长度
min_fit=[];
while Tf<=T
    for i=1:Markov_length
        % 产生新的解（随机产生3个交叉点，交换2段的位置）
        idx=sort(randi(city_num,1,3));
        temp=sol_new1;
        sol_new1=[temp(1:idx(1)),temp(idx(2)+1:idx(3)),temp(idx(1)+1:idx(2)),temp(idx(3)+1:end)];
        temp1=sol_new2;
        sol_new2=[temp1(1:idx(1)),temp1(idx(2)+1:idx(3)),temp1(idx(1)+1:idx(2)),temp1(idx(3)+1:end)];
        %计算新解的目标函数值
        E_new=cal_distance(sol_new1,sol_new2,h);
        %退火操作
        if E_new < E_current
            E_current=E_new;
            sol_current1=sol_new1;
            sol_current2=sol_new2;
            if E_new < E_best
                E_best=E_new;
                sol_best1=sol_new1;
                sol_best2=sol_new2;
            end
        else
            % 若新解目标函数值大于当前解，则以一定概率接受
            if rand() < exp(-(E_new-E_current)/T)
                E_current=E_new;
                sol_current1=sol_new1;
                sol_current2=sol_new2;
            else
                % 不接受新解
                sol_new1=sol_current1;
                sol_new2=sol_current2;
            end
        end
    end
    T=0.99*T;
    min_fit=[min_fit E_best];
end
hold off
figure(1)
plot(1:length(min_fit),min_fit)
% disp('最优解为：');
% disp(E_best);
figure(2)
drawBest(data,sol_best1,city_num)
[~,tt]=find(sol_best1==1);
rout=[sol_best1(tt:end),sol_best1(1:tt-1)];
pp=[sol_best2(tt:end),sol_best2(1:tt-1)];
jie_zhyy2=cell(1,size(data,1)+1);
disp('最优的登记设施信息的巡视路线及长度如下：')
for i=1:size(data,1)
    fprintf('%d',rout(i));
    jie_zhyy2{i}.coordinate=h(rout(i),:);
    switch pp(i)
        case 1
            jie_zhyy2{i}.pos='A';
            fprintf('(%s)','A');
        case 2
            jie_zhyy2{i}.pos='B';
            fprintf('(%s)','B');
        case 3
            jie_zhyy2{i}.pos='C';
            fprintf('(%s)','C');
        case 4
            jie_zhyy2{i}.pos='D';
            fprintf('(%s)','D');
    end
    fprintf('->');
end
jie_zhyy2{end}.coordinate=h(1,:);
fprintf('%d',1);
switch pp(1)
    case 1
        jie_zhyy2{end}.pos='A';
        fprintf('(%s)','A');
    case 2
        jie_zhyy2{end}.pos='B';
        fprintf('(%s)','B');
    case 3
        jie_zhyy2{end}.pos='C';
        fprintf('(%s)','C');
    case 4
        jie_zhyy2{end}.pos='D';
        fprintf('(%s)','D');
end
fprintf('\n');
fprintf('长度=%d\n',E_best);

% 计算一个解的行驶总距离
function [dis]=cal_distance(city_order,city_pos,h)
dis=0;
N=length(city_order);
for k=1:N-1
%     dis=dis+h(city_order(k),city_order(k+1));
    if city_pos(k) == 1
        vex1=[h(city_order(k),1) h(city_order(k),2)-0.5];
    elseif city_pos(k) == 2
        vex1=[h(city_order(k),1)-0.5 h(city_order(k),2)];
    elseif city_pos(k) == 3
        vex1=[h(city_order(k),1)+0.5 h(city_order(k),2)];
    else
        vex1=[h(city_order(k),1) h(city_order(k),2)+0.5];
    end
    if city_pos(k+1) == 1
        vex2=[h(city_order(k+1),1) h(city_order(k+1),2)-0.5];
    elseif city_pos(k+1) == 2
        vex2=[h(city_order(k+1),1)-0.5 h(city_order(k+1),2)];
    elseif city_pos(k+1) == 3
        vex2=[h(city_order(k+1),1)+0.5 h(city_order(k+1),2)];
    else
        vex2=[h(city_order(k+1),1) h(city_order(k+1),2)+0.5];
    end
    if vex1(1)==vex2(1)
        if vex1(1)==h(city_order(k),1)
            dis=dis+abs(vex1(2)-vex2(2))+1;
        else
            dis=dis+abs(vex1(2)-vex2(2))+abs(vex1(1)-vex2(1));
        end
    else
        if vex1(2)==vex2(2)
            if vex1(2)==h(city_order(k),2)
                dis=dis+abs(vex1(1)-vex2(1))+1;
            else
                dis=dis+abs(vex1(2)-vex2(2))+abs(vex1(1)-vex2(1));
            end
        else
            dis=dis+abs(vex1(2)-vex2(2))+abs(vex1(1)-vex2(1));
        end
    end
end
if city_pos(end) == 1
    vex1=[h(city_order(end),1) h(city_order(end),2)-0.5];
elseif city_pos(end) == 2
    vex1=[h(city_order(end),1)-0.5 h(city_order(end),2)];
elseif city_pos(end) == 3
    vex1=[h(city_order(end),1)+0.5 h(city_order(end),2)];
else
    vex1=[h(city_order(end),1) h(city_order(end),2)+0.5];
end
if city_pos(1) == 1
    vex2=[h(city_order(1),1) h(city_order(1),2)-0.5];
elseif city_pos(1) == 2
    vex2=[h(city_order(1),1)-0.5 h(city_order(1),2)];
elseif city_pos(1) == 3
    vex2=[h(city_order(1),1)+0.5 h(city_order(1),2)];
else
    vex2=[h(city_order(1),1) h(city_order(1),2)+0.5];
end
if vex1(1)==vex2(1)
    if vex1(1)==h(city_order(end),1)
        dis=dis+abs(vex1(2)-vex2(2))+1;
    else
        dis=dis+abs(vex1(2)-vex2(2))+abs(vex1(1)-vex2(1));
    end
else
    if vex1(2)==vex2(2)
        if vex1(2)==h(city_order(end),2)
            dis=dis+abs(vex1(1)-vex2(1))+1;
        else
            dis=dis+abs(vex1(2)-vex2(2))+abs(vex1(1)-vex2(1));
        end
    else
        dis=dis+abs(vex1(2)-vex2(2))+abs(vex1(1)-vex2(1));
    end
end
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
