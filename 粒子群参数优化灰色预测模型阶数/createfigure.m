function createfigure(X1, YMatrix1)
%CREATEFIGURE1(X1, YMATRIX1)
%  X1:  x ���ݵ�ʸ��
%  YMATRIX1:  y ���ݵľ���

%  �� MATLAB �� 15-Mar-2022 18:55:32 �Զ�����

% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% ʹ�� plot �ľ������봴������
plot1 = plot(X1,YMatrix1);
set(plot1(1),'DisplayName','ʵ��ֵ','Marker','*','Color',[1 0 0]);
set(plot1(2),'DisplayName','Ԥ��ֵ','Marker','o','Color',[0 0 1]);

% ���� xlabel
xlabel({'���'},'HorizontalAlignment','center');

% ���� ylabel
ylabel('GDP');

box(axes1,'on');
% ������������������
set(axes1,'XTickLabel',...
    {'2013','2014','2015','2016','2017','2018','2019','2020'});
% ���� legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.760816452428594 0.234489266087224 0.0962389368662792 0.0501373613273704]);

