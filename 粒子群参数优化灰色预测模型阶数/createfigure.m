function createfigure(X1, YMatrix1)
%CREATEFIGURE1(X1, YMATRIX1)
%  X1:  x 数据的矢量
%  YMATRIX1:  y 数据的矩阵

%  由 MATLAB 于 15-Mar-2022 18:55:32 自动生成

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(X1,YMatrix1);
set(plot1(1),'DisplayName','实际值','Marker','*','Color',[1 0 0]);
set(plot1(2),'DisplayName','预测值','Marker','o','Color',[0 0 1]);

% 创建 xlabel
xlabel({'年份'},'HorizontalAlignment','center');

% 创建 ylabel
ylabel('GDP');

box(axes1,'on');
% 设置其余坐标轴属性
set(axes1,'XTickLabel',...
    {'2013','2014','2015','2016','2017','2018','2019','2020'});
% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.760816452428594 0.234489266087224 0.0962389368662792 0.0501373613273704]);

