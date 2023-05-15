clc;
clear;
close all;

%% 模型参数
commodity_pos=importdata('position.txt');
out_order_data=importfile('pre_out_order_data.txt',',');%出库订单数据
in_order_data=importfile('pre_in_order_data.txt',',');%入库订单数据

% 设置参数为全局变量
global out_order_pos in_order_pos warehouse;

out_order_pos=commodity_pos([out_order_data{:}],:);%出库商品坐标
in_order_pos=commodity_pos([in_order_data{:}],:);%入库商品坐标
%将两者对齐
task_num=max(size(out_order_pos,1),size(in_order_pos,1));%任务数量
out_num=size(out_order_pos,1);
in_num=size(in_order_pos,1);
out_order_pos(size(out_order_pos,1)+1:task_num,:)=zeros(task_num-size(out_order_pos,1),3);
in_order_pos(size(in_order_pos,1)+1:task_num,:)=zeros(task_num-size(in_order_pos,1),3);
% 设置仓库参数
warehouse.t_sf=1;
warehouse.t_sr=1.5;
warehouse.t_cf=1;
warehouse.t_cr=1.5;
warehouse.t_zf=1;
warehouse.t_zr=1.5;
warehouse.v_c=1.5;%穿梭车的速度
warehouse.v_s=1.5;%升降机的速度
warehouse.a_c=1;%穿梭车的加速度
warehouse.a_s=1;%升降机的加速度
warehouse.l=1.5;%货位长度
warehouse.h=2;%货架的高度

%% 算法参数
N = 100;       % 灰狼个数
Max_iter = 200;  % 最大迭代次数
lb = -task_num-50;   % Lower Bound
ub = task_num+50;   % Upper Bound
dim = task_num;   % 维数
fobj=@cal_fitness;%适应度函数

%% 运行GWO算法
[Best_score,Best_pos,GWO_cg_curve]=GWO(N,Max_iter,lb,ub,dim,fobj);
fid = fopen('result.txt','w');
fprintf(fid,'最优目标值：%.4f',Best_score);
[~,seq]=sort(Best_pos);
fprintf(fid,'配对结果如下(%d个入库任务->%d个出库任务)：\n',in_num,out_num);
for i=1:length(seq)
    if seq(i)>out_num
        if i<=in_num
            fprintf(fid,'%d->%d\n',i,0);
        end
    else
        if i<=in_num
            fprintf(fid,'%d->%d\n',i,seq(i));
        else
            fprintf(fid,'%d->%d\n',0,seq(i));
        end
    end
end
fclose(fid);
figure(1);
hold on
plot(GWO_cg_curve,'Color','red','LineWidth',1.0);
title('迭代收敛图');
xlabel('迭代次数','FontWeight','bold','FontSize',11,'FontName','宋体');
ylabel('适应度值','FontWeight','bold','FontSize',11,'FontName','宋体');













