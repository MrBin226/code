clc;
clear;
close all;

%% 读取相关数据
% order_data=importfile('order.txt',',');%订单数据
% due_time=importfile('due.txt',',');%订单截止时间
% due_time=cell2mat(due_time);
order_data=arrayfun(@(x) randperm(100,randi([4 6])),1:100,'UniformOutput',0)';
due_time=randi([1,60],100,1);
% save 100_order.mat
% load('30_order.mat');
shelve_data=reshape(1:100,5,20)';%货架上存放商品信息
shelve_data=num2cell(shelve_data,2);

order_num=size(order_data,1);%订单数量
C=6;%每个批次中的最大订单数量
E=2;%每个批次中的最小订单数量
batch_num=floor(order_num/E);%最大批次数
t1=0.7;%移动机器人搬运一次货架的时间
t2=0.3;%拣货员拣选一次SKU的时间
F0=0.5;     %变异因子
CR=0.4;     %交叉概率
MaxGens=100;
x_high=batch_num;
x_low=1;
D=order_num;
NP=50;

pop=init(NP,D,E,C,x_low,x_high); %初始化种群
g=1;        %迭代标记
fit=cal_fitness(pop,order_data,shelve_data,due_time,t1,t2,C,E);
[trace(1),ind]=min(fit);
best_fit=trace(1);
best_sol=pop(ind,:);
v=zeros(NP,D);      %竞争矩阵
tic
for gen=1:MaxGens
    %   变异操作
    for i=1:NP
        r1=randi([1,NP],1,1);
        pop_s = fit(r1);
        while(pop_s<fit(i))
            r1 =randi([1,NP],1,1);
            pop_s = fit(r1);
        end
        %产生r2,r3
        r2=randi([1,NP],1,1);
         while(r2==r1)||(r2==i)
            r2=randi([1,NP],1,1);
         end
        r3=randi([1,NP],1,1);
        while(r3==i)||(r3==r2)||(r3==r1)
            r3=randi([1,NP],1,1);
        end
        %交叉
        Z=randi([1,D],1,1);
        r=rand;
        for j = 1:D 
            if (r<=CR) || (j==Z)
                v(i,j)=round((pop(r1,j)+pop(i,j))/2+F0*(pop(r1,j)-pop(i,j)+pop(r2,j)-pop(r3,j)));
            else
                v(i,j)=pop(i,j);
            end
        end
        % 边界约束
        v(i,v(i,:)>x_high)=x_high;
        v(i,v(i,:)<x_low)=x_low;
        % 调整个体
        v(i,:)=adjust_sol(v(i,:),E,C,due_time,order_data,shelve_data,t1,t2,x_low,x_high);
        % 进行局部搜索
        v(i,:)=LargeSearch(v(i,:),E,C,due_time,order_data,shelve_data,t1,t2,x_low,x_high);
%         % 选择
%         if cal_fitness(v(i,:),order_data,shelve_data,due_time,t1,t2,C,E)<cal_fitness(pop(i,:),order_data,shelve_data,due_time,t1,t2,C,E)
%             pop(i,:)=v(i,:);
%         end
        new_fit=cal_fitness(v(i,:),order_data,shelve_data,due_time,t1,t2,C,E);
        if new_fit<best_fit
            best_fit=new_fit;
            best_sol=v(i,:);
        end
    end
    pop=v;
    fit=cal_fitness(pop,order_data,shelve_data,due_time,t1,t2,C,E);
    trace(gen+1)=best_fit;
    fprintf('第%d次迭代，目标函数为：%d\n',gen,best_fit);
end

disp('分批结果如下：')
temp=unique(best_sol);
for j=1:length(temp)
    fprintf('第%d批：',j);
    batch=find(best_sol==temp(j));
    arrayfun(@(x) fprintf('%d   ',x),batch);
    fprintf('\n');
end
toc

tic
[trace1,best_sol1,best_fit1]=DE_base(order_data,due_time,shelve_data);
toc

figure(1);
hold on
plot(trace,'Color','red','LineWidth',1.0);
plot(trace1,'Color','blue','LineWidth',1.0);
title('算法对比');
xlabel('迭代次数','FontWeight','bold','FontSize',11,'FontName','宋体');
ylabel('适应度值','FontWeight','bold','FontName','宋体');
legend('改进DE','DE')
box on
hold off
% save('100_data.mat','trace','best_sol','best_fit')
% save('100_data1.mat','trace1','best_sol1','best_fit1')

%% 初始化种群
function pop=init(NP,D,E,C,x_low,x_high)
pop=zeros(NP,D);
for i=1:NP
    while 1
        chrom=zeros(1,D);
        num=randi([E,C],1);
        order=randperm(D);
        one_batch=[];
        k=1;
        pos=x_low:x_high;
        for j=1:D
            if k<=num
                one_batch=[one_batch, order(j)];
                k=k+1;
            else
                r=pos(randi(numel(pos),1));
                chrom(one_batch)=r;
                pos=setdiff(pos,r,'stable');
                one_batch=[order(j)];
                k=2;
                num=randi([E,C],1);
            end
        end
        if length(one_batch)>=E
            r=pos(randi(numel(pos),1));
            chrom(one_batch)=r;
            break
        end
    end
    pop(i,:)=chrom;
end
end

%% 计算目标函数
function len=cal_fitness(pop,order_data,shelve_data,due_time,t1,t2,C,E)
NIND=size(pop,1);
len=zeros(NIND,1);
for i=1:NIND
    temp=unique(pop(i,:));
    T=0;
    for j=1:length(temp)
        batch=find(pop(i,:)==temp(j));
        if length(batch)>C || length(batch)<E
            T=inf;
            break
        end
        temp_batch=unique(cell2mat(order_data(batch)'));
        temp_shelve=get_order_shelve(temp_batch,shelve_data);
        t_start=t1*length(temp_shelve)+t2*length(temp_batch);
        t_due=t_start-due_time(batch);
        t_due(t_due<0)=0;
        T=T+sum(t_due);
    end
    len(i,1)=T;
end
end

%% 对个体进行解码
function [order_batch,batch_code]=decode(chrom)
order_batch={};
temp=unique(chrom);
for j=1:length(temp)
    batch=find(chrom==temp(j));
    order_batch{end+1}=batch;
    batch_code(j)=temp(j);
end
end

%% 对不满足约束的个体进行调整
function new_chrom=adjust_sol(chrom,E,C,due_time,order_data,shelve_data,t1,t2,x_low,x_high)
[order_batch,batch_code]=decode(chrom);
batch_length=cellfun(@length,order_batch);
idx=find(batch_length>C);
if ~isempty(idx)
    removeCus=[];
    for i=1:length(idx)
        temp_batch=order_batch{idx(i)}(randperm(length(order_batch{idx(i)}),C));
%         temp_batch=nchoosek(order_batch{idx(i)},C);
%         temp_ba=unique(cell2mat(order_data(order_batch{idx(i)})'));
%         temp_shelve=get_order_shelve(temp_ba,shelve_data);
%         t_start=t1*length(temp_shelve)+t2*length(temp_ba);
%         t_due=t_start-due_time(order_batch{idx(i)});
%         t_due(t_due<0)=0;
%         T=sum(t_due);
%         T_diff=[];
%         for j=1:size(temp_batch,1)
%             temp_ba=unique(cell2mat(order_data(temp_batch(j,:))'));
%             temp_shelve=get_order_shelve(temp_ba,shelve_data);
%             t_start=t1*length(temp_shelve)+t2*length(temp_ba);
%             t_due=t_start-due_time(temp_batch(j,:));
%             t_due(t_due<0)=0;
%             T_diff(j)=sum(t_due)-T;
%         end
%         [~,tt]=min(T_diff);
        tt=randi(size(temp_batch,1),1);
        removeCus=[removeCus setdiff(order_batch{idx(i)},temp_batch(tt,:))];
        order_batch{idx(i)}=temp_batch(tt,:);
        batch_length(idx(i))=C;
    end
    for k=1:length(removeCus)
        locat=find(batch_length<C);
        if ~isempty(locat)
            t_diff=[];
            for j=1:length(locat)
                temp_ba=unique(cell2mat(order_data(order_batch{locat(j)})'));
                temp_shelve=get_order_shelve(temp_ba,shelve_data);
                t_start=t1*length(temp_shelve)+t2*length(temp_ba);
                t_due=t_start-due_time(order_batch{locat(j)});
                t_due(t_due<0)=0;
                t_diff(j)=sum(t_due);
                temp_ba=unique(cell2mat(order_data([order_batch{locat(j)},removeCus(k)])'));
                temp_shelve=get_order_shelve(temp_ba,shelve_data);
                t_start=t1*length(temp_shelve)+t2*length(temp_ba);
                t_due=t_start-due_time([order_batch{locat(j)},removeCus(k)]);
                t_due(t_due<0)=0;
                t_diff(j)=sum(t_due)-t_diff(j);
            end
            [~,tt]=min(t_diff);
            order_batch{locat(tt)}=[order_batch{locat(tt)} removeCus(k)];
            batch_length(locat(tt))=batch_length(locat(tt))+1;
        else
            order_batch{end+1}=removeCus(k);
            batch_length(end+1)=1;
            cod=setdiff(x_low:x_high,batch_code);
            batch_code(end+1)=cod(randi(numel(cod),1));
        end
    end
end
idx=find(batch_length<E);
if ~isempty(idx)
    while ~isempty(idx)
        removeCus=order_batch{idx(1)};
        order_batch(idx(1))=[];
        batch_length=cellfun(@length,order_batch);
        batch_code(idx(1))=[];
        for k=1:length(removeCus)
            locat=find(batch_length<C);
            if ~isempty(locat)
                t_diff=[];
                for j=1:length(locat)
                    temp_ba=unique(cell2mat(order_data(order_batch{locat(j)})'));
                    temp_shelve=get_order_shelve(temp_ba,shelve_data);
                    t_start=t1*length(temp_shelve)+t2*length(temp_ba);
                    t_due=t_start-due_time(order_batch{locat(j)});
                    t_due(t_due<0)=0;
                    t_diff(j)=sum(t_due);
                    temp_ba=unique(cell2mat(order_data([order_batch{locat(j)},removeCus(k)])'));
                    temp_shelve=get_order_shelve(temp_ba,shelve_data);
                    t_start=t1*length(temp_shelve)+t2*length(temp_ba);
                    t_due=t_start-due_time([order_batch{locat(j)},removeCus(k)]);
                    t_due(t_due<0)=0;
                    t_diff(j)=sum(t_due)-t_diff(j);
                end
                [~,tt]=min(t_diff);
                order_batch{locat(tt)}=[order_batch{locat(tt)} removeCus(k)];
                batch_length(locat(tt))=batch_length(locat(tt))+1;
            else
                order_batch{end+1}=removeCus(k);
                batch_length(end+1)=1;
                cod=setdiff(x_low:x_high,batch_code);
                batch_code(end+1)=cod(randi(numel(cod),1));
            end
        end
        idx=find(batch_length<E);
    end  
end
new_chrom=zeros(size(chrom));
for i=1:length(order_batch)
    new_chrom(order_batch{i})=batch_code(i);
end
end

%% 邻域搜索
function new_chrom=LargeSearch(chrom,E,C,due_time,order_data,shelve_data,t1,t2,x_low,x_high)
[order_batch,batch_code]=decode(chrom);
len=floor(length(order_batch)/4);
for k=1:length(order_batch)
    temp_batch=unique(cell2mat(order_data(order_batch{k})'));
    temp_shelve=get_order_shelve(temp_batch,shelve_data);
    t_start=t1*length(temp_shelve)+t2*length(temp_batch);
    t_due=t_start-due_time(order_batch{k});
    t_due(t_due<0)=0;
    T(k)=sum(t_due);
end
[~,tt]=sort(T,'descend');
removeCus=cell2mat(order_batch(tt(1:len)));
order_batch(tt(1:len))=[];
batch_code(tt(1:len))=[];
batch_length=cellfun(@length,order_batch);
for k=1:length(removeCus)
    locat=find(batch_length<C);
    if ~isempty(locat)
        t_diff=[];
        for j=1:length(locat)
            temp_ba=unique(cell2mat(order_data(order_batch{locat(j)})'));
            temp_shelve=get_order_shelve(temp_ba,shelve_data);
            t_start=t1*length(temp_shelve)+t2*length(temp_ba);
            t_due=t_start-due_time(order_batch{locat(j)});
            t_due(t_due<0)=0;
            t_diff(j)=sum(t_due);
            temp_ba=unique(cell2mat(order_data([order_batch{locat(j)},removeCus(k)])'));
            temp_shelve=get_order_shelve(temp_ba,shelve_data);
            t_start=t1*length(temp_shelve)+t2*length(temp_ba);
            t_due=t_start-due_time([order_batch{locat(j)},removeCus(k)]);
            t_due(t_due<0)=0;
            t_diff(j)=sum(t_due)-t_diff(j);
        end
        [~,tt]=min(t_diff);
        if t_diff(tt) <= 0
            order_batch{locat(tt)}=[order_batch{locat(tt)} removeCus(k)];
            batch_length(locat(tt))=batch_length(locat(tt))+1;
        else
            if length(order_batch)<x_high
                order_batch{end+1}=removeCus(k);
                batch_length(end+1)=1;
                cod=setdiff(x_low:x_high,batch_code);
                batch_code(end+1)=cod(randi(numel(cod),1));
            else
                order_batch{locat(tt)}=[order_batch{locat(tt)} removeCus(k)];
                batch_length(locat(tt))=batch_length(locat(tt))+1;
            end
        end
        
    else
        order_batch{end+1}=removeCus(k);
        batch_length(end+1)=1;
        cod=setdiff(x_low:x_high,batch_code);
        batch_code(end+1)=cod(randi(numel(cod),1));
    end
end
new_chrom=zeros(size(chrom));
for i=1:length(order_batch)
    new_chrom(order_batch{i})=batch_code(i);
end
if ~isempty(find(batch_length<E, 1))
    new_chrom=adjust_sol(new_chrom,E,C,due_time,order_data,shelve_data,t1,t2,x_low,x_high);
end
end




