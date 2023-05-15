clc;
clear all;
close all;

%% 模型参数设置
pick_coord=importdata('拣选台坐标.txt');%获取拣选台坐标
pick_num=size(pick_coord,1);%拣选台数量
cargo_coord=importdata('货物坐标.txt');%获取仓库内各个货物坐标
cargo_coord=cargo_coord.data;
order_data=importfile('订单信息.txt','|');%获取订单相关信息
order=arrayfun(@(x) order_data(x).order,1:length(order_data),'UniformOutput',0)';%得到订单数据
order_cargo_num=arrayfun(@(x) order_data(x).count,1:length(order_data),'UniformOutput',0)';%得到订单数据
shelve_info=get_shelve_info('货架商品信息.txt',',');%获取仓库内各个货架存放的商品
q=35;%拣选台最大容量
%将订单内全部货物全部合并，数量相加
temp_cargo=cell2mat(order');
temp_num=cell2mat(order_cargo_num');
cargo=unique(temp_cargo);%订单的全部货物
cargo_num=arrayfun(@(x) sum(temp_num(temp_cargo==cargo(x))),1:length(cargo));%相应的货物数量
v=1;%AGV的速度
Tb=10;

%% 算法参数设置
SearchAgents_no=10;%灰狼个数
dim=length(cargo);%维度
lb=1;%下界
ub=pick_num+0.99;%上界
Max_iter=100;%最大迭代次数
Alpha_pos=zeros(1,dim);
Alpha_score=inf;
Beta_pos=zeros(1,dim);
Beta_score=inf; 
Delta_pos=zeros(1,dim);
Delta_score=inf;
Convergence_curve=zeros(1,Max_iter);
a_ini=2;
a_fin=0;

%% 初始化
Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
% 对解位置进行调整保证每个拣选台都进行服务

l=0;% 循环计数

%% 开始循环
while l<Max_iter
    for i=1:size(Positions,1)  
        
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;   
        Positions(i,:) = adjust(Positions(i,:),pick_num,cargo,cargo_num,q,cargo_coord,pick_coord);
        
        fitness=cal_obj(Positions(i,:),cargo_coord,cargo,pick_num,pick_coord,v,order,cargo_num,q,Tb);
        
        if fitness<Alpha_score 
            Alpha_score=fitness;
            Alpha_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness<Beta_score 
            Beta_score=fitness; 
            Beta_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score 
            Delta_score=fitness;
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=a_ini-(a_ini-a_fin)*(l/Max_iter)^2;
    
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)     
                       
            r1=rand(); 
            r2=rand();
            
            A1=2*a*r1-a; 
            C1=2*r2;
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j));
            X1=Alpha_pos(j)-A1*D_alpha; 
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; 
            C2=2*r2; 
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); 
            X2=Beta_pos(j)-A2*D_beta;     
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a;
            C3=2*r2;
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); 
            X3=Delta_pos(j)-A3*D_delta;             
            
            Positions(i,j)=(X1+X2+X3)/3;
            
        end
    end
    l=l+1;    
    Convergence_curve(l)=Alpha_score;
    fprintf('第%d次迭代，最优目标值为：%d\n',l,Alpha_score);
end

[fitness,dis,time,pick_to_cargos] = cal_obj(Alpha_pos,cargo_coord,cargo,pick_num,pick_coord,v,order,cargo_num,q,Tb);
fprintf('最优目标函数值：%d，搬运时间为：%ds，包装时间为：%ds',fitness,sum(dis)/v,time);
all_num=0;
for i=1:pick_num
    for k=1:length(pick_to_cargos{i})
        for kk=1:length(shelve_info)
            if ~isempty(find(shelve_info{kk}==pick_to_cargos{i}(k)))
                shelve(k)=kk;
                break
            end
        end
    end
    all_num=all_num+length(unique(shelve));
end
fprintf(',总的搬运次数为：%d\n',all_num);
for i=1:pick_num
    fprintf('第%d个拣选台按次序拣选的货物：拣选台%d->',i,i);
    for k=1:length(pick_to_cargos{i})
        fprintf('货物%d->',pick_to_cargos{i}(k));
    end
    fprintf('拣选台%d,搬运距离为：%d,搬运次数为：%d\n',i,dis(i),length(unique(shelve)));
end

figure(1)
plot(Convergence_curve);
xlabel('迭代次数')
ylabel('目标函数值')
title('GWO迭代过程')





