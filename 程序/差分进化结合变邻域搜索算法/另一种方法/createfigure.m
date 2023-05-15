function createfigure(YMatrix1)
%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  y 数据的矩阵

%  由 MATLAB 于 06-Dec-2021 19:39:55 自动生成

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(YMatrix1,'LineWidth',1.5,'Parent',axes1);
set(plot1(1),'DisplayName','IMPA','Color',[1 0 0]);
set(plot1(2),'DisplayName','MMPA','Color',[1 0 1]);
set(plot1(3),'DisplayName','LEO-MPA','Color',[0 0 1]);
set(plot1(4),'DisplayName','LMMPA',...
    'Color',[0.600000023841858 0.200000002980232 0]);
set(plot1(5),'DisplayName','ODMPA','Color',[0 0 0]);

% 创建 xlabel
xlabel('迭代次数','FontWeight','bold','FontSize',11,'FontName','宋体');

% 创建 ylabel
ylabel('适应度值','FontWeight','bold','FontName','宋体');

box on

% 创建 legend
legend(axes1,'show');

