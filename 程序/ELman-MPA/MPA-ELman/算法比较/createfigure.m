function createfigure(YMatrix1,til)
%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  y 数据的矩阵

%  由 MATLAB 于 06-Dec-2021 19:39:55 自动生成

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(YMatrix1,'LineWidth',1.0,'Parent',axes1);
set(plot1(1),'DisplayName','MMPA','Color','red');
set(plot1(2),'DisplayName','MPA','Color','blue');
set(plot1(3),'DisplayName','GWO','Color','black');
set(plot1(4),'DisplayName','PSO','Color','cyan');

% 创建 xlabel
xlabel('Iterations','FontWeight','bold','FontSize',11,'FontName','Times New Roman');

% 创建 ylabel
ylabel('Best fitness','FontWeight','bold','FontName','Times New Roman');
title({til},'FontSize',11,...
    'FontName','Times New Roman',...
    'Interpreter','latex');
box on

% 创建 legend
legend(axes1,'show');

