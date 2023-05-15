function createfigure(YMatrix1,til)
%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  y ���ݵľ���

%  �� MATLAB �� 06-Dec-2021 19:39:55 �Զ�����

% ���� figure
figure1 = figure;

% ���� axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% ʹ�� plot �ľ������봴������
plot1 = plot(YMatrix1,'LineWidth',1.0,'Parent',axes1);
set(plot1(1),'DisplayName','MMPA','Color','red');
set(plot1(2),'DisplayName','MPA','Color','blue');
set(plot1(3),'DisplayName','GWO','Color','black');
set(plot1(4),'DisplayName','PSO','Color','cyan');

% ���� xlabel
xlabel('Iterations','FontWeight','bold','FontSize',11,'FontName','Times New Roman');

% ���� ylabel
ylabel('Best fitness','FontWeight','bold','FontName','Times New Roman');
title({til},'FontSize',11,...
    'FontName','Times New Roman',...
    'Interpreter','latex');
box on

% ���� legend
legend(axes1,'show');

