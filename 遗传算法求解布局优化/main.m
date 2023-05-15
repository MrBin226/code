clc;
clear;
close all;
nchr = 50;%种群数量
G = 200;%代终止数
pc = 0.8;%交叉概率
pm = 0.1;%变异概率
%定义全局变量,H为车间总宽，L为车间总长，DeviceSize为各个车间尺寸，Cij为运输费用，Qij为物流量
%delta为各个车间的最小间距,Tij为相互关系矩阵，Bij为关联因子，T为惩罚系数
global H L DeviceSize T Cij Qij delta Tij Bij;
H = 100;%车间宽
L = 180;%车间长
DeviceSize = [36 18;36 18;36 18;36 18;36 18;36 18;...
    30 18;36 18;24 18;18 18;26 18;36 18;24 18];
Cij=1.5*ones(13);
Qij=xlsread('实验数据.xlsx','E25:Q37');
Qij(isnan(Qij))=0;
Tij=xlsread('实验数据.xlsx','E48:Q60');
delta=xlsread('实验数据.xlsx','E7:Q19');
Bij=[0 46.67 1;...
    46.67 93.33 0.8;...
    93.33 140 0.6;...
	140 186.67 0.4;...
	186.67 233.33 0.2;...
	233.33 280 0];
T=10;

[chrx,MOC,PkG,LayoutG,best_X,best_Y] = GA(nchr,G,pc,pm);
best_Layout=LayoutG{end};
best_Layout(cellfun(@isempty,best_Layout))=[];
disp('最优布局如下：');
for i=1:length(best_Layout)
    line=best_Layout{i};
    fprintf('第%d行：',i);
    for j=1:length(line)
        fprintf('车间%d\t',line(j));
    end
    fprintf('\n');
end
figure(1)
plot(1:G,MOC);
xlabel('进化次数');
ylabel('最优目标函数值');
title('进化次数同目标函数值曲线')
figure(2)
hold on
axis([0 L 0 H]);
for i=1:size(DeviceSize,1)
    rectangle('Position',[best_X(end,i)-DeviceSize(i,1)/2,best_Y(end,i)-DeviceSize(i,2)/2,DeviceSize(i,1),DeviceSize(i,2)]);
    text(best_X(end,i)-0.5,best_Y(end,i),num2str(i));
end
title('最优布局图');
xlabel('横坐标');
ylabel('纵坐标');
hold off

