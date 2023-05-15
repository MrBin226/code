function createfigure(YMatrix1)
%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  y ���ݵľ���

%  �� MATLAB �� 06-Dec-2021 19:39:55 �Զ�����

% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% ʹ�� plot �ľ������봴������
plot1 = plot(YMatrix1,'LineWidth',1.5,'Parent',axes1);
set(plot1(1),'DisplayName','IMPA','Color',[1 0 0]);
set(plot1(2),'DisplayName','MMPA','Color',[1 0 1]);
set(plot1(3),'DisplayName','LEO-MPA','Color',[0 0 1]);
set(plot1(4),'DisplayName','LMMPA',...
    'Color',[0.600000023841858 0.200000002980232 0]);
set(plot1(5),'DisplayName','ODMPA','Color',[0 0 0]);

% ���� xlabel
xlabel('��������','FontWeight','bold','FontSize',11,'FontName','����');

% ���� ylabel
ylabel('��Ӧ��ֵ','FontWeight','bold','FontName','����');

box on

% ���� legend
legend(axes1,'show');

