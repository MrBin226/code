clc;             %�������ڵ�����
clear all;       %��������ռ�����б�������������MEX�ļ�
close all;       %�ر����е�figure����

n = 20;   % ����һ��n x n�ķ����޸Ĵ�ֵ�����޸�����ͼƬ�ķ�����
wallpercent = 0.4;  % ��������������ɵ��ϰ���ռ�ܷ������ı��� ����0.5 ��ʾ�ϰ���ռ�ܸ�����50%

[field, startposind, goalposind, costchart, fieldpointers] =initializeField(n,wallpercent);
createFigure(field,costchart,startposind,goalposind)




%% 
function [field, startposind, goalposind, costchart, fieldpointers] = ...
  initializeField(n,wallpercent)
    field = ones(n,n) + 10*rand(n,n);%����һ��n*n�ĵ�λ����+0��10��Χ�ڵ�һ�������
    field(ind2sub([n n],ceil(n^2.*rand(n*n*wallpercent,1)))) = Inf;%����ȡ��
    % ���������ʼ�����ֹ��
    startposind = sub2ind([n,n],ceil(n.*rand),ceil(n.*rand));  %���������ʼ�������ֵ
    goalposind = sub2ind([n,n],ceil(n.*rand),ceil(n.*rand));   %���������ֹ�������ֵ
    field(startposind) = 0; field(goalposind) = 0;  %�Ѿ�������ʼ�����ֹ�㴦��ֵ��Ϊ0
    
    costchart = NaN*ones(n,n);%����һ��nxn�ľ���costchart��ÿ��Ԫ�ض���ΪNaN�����Ǿ����ʼNaN��Ч����
    costchart(startposind) = 0;%�ھ���costchart�н���ʼ��λ�ô���ֵ��Ϊ0
    
    % ����Ԫ������
    fieldpointers = cell(n,n);%����Ԫ������n*n
    fieldpointers{startposind} = 'S'; fieldpointers{goalposind} = 'G'; %��Ԫ���������ʼ���λ�ô���Ϊ 'S'����ֹ�㴦��Ϊ'G'
    fieldpointers(field==inf)={0};
    
   
end

%%

function axishandle = createFigure(field,costchart,startposind,goalposind)

      % ���if..else�ṹ���������ж����û�д򿪵�figureͼ������������ô���һ��figureͼ
      if isempty(gcbf)                                       %gcbf�ǵ�ǰ����ͼ��ľ����isempty(gcbf)����gcbfΪ�յĻ������ص�ֵ��1������gcbfΪ�ǿյĻ������ص�ֵ��0
      figure('Position',[450 100 700 700], 'MenuBar','none');  %�Դ�����figureͼ��������ã������������Ļ���ľ���Ϊ450��������Ļ�·��ľ���Ϊ50�����ȺͿ�ȶ�Ϊ700�����ҹر�ͼ��Ĳ˵���
      axes('position', [0.01 0.01 0.99 0.99]);               %�����������λ�ã����½ǵ�������Ϊ0.01,0.01   ���Ͻǵ�������Ϊ0.99 0.99  ��������Ϊfigureͼ�����½�����Ϊ0 0   �����Ͻ�����Ϊ1 1 ��
      else
      gcf; cla;   %gcf ���ص�ǰ Figure ����ľ��ֵ��Ȼ������cla����������
      end
      
      n = length(field);  %��ȡ����ĳ��ȣ�����ֵ������n
      field(field < Inf) = 0; %��fieid�����е��������Ҳ����û���ϰ����λ�ô�����Ϊ0
      pcolor(1:n+1,1:n+1,[field field(:,end); field(end,:) field(end,end)]);%�����һ���ظ��ģ���n X n��Ϊ n+1 X n+1 ��
 
      cmap = flipud(colormap('jet'));  %���ɵ�cmap��һ��256X3�ľ���ÿһ�е�3��ֵ��Ϊ0-1֮�������ֱ������ɫ��ɵ�rgbֵ
      cmap(1,:) = zeros(3,1); cmap(end,:) = ones(3,1); %������cmap�ĵ�һ����Ϊ0 �����һ����Ϊ1
      colormap(flipud(cmap)); %������ɫ�ĵ�ת 
      hold on;
   
    axishandle = pcolor([1:n+1],[1:n+1],[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);  %������costchart������չ����ֵ��ɫ�󸳸�axishandle
   
    [goalposy,goalposx] = ind2sub([n,n],goalposind);
    [startposy,startposx] = ind2sub([n,n],startposind);
    plot(goalposx+0.5,goalposy+0.5,'ys','MarkerSize',10,'LineWidth',6);
    plot(startposx+0.5,startposy+0.5,'go','MarkerSize',10,'LineWidth',6);
  
    uicontrol('Style','pushbutton','String','RE-DO', 'FontSize',12, ...
      'Position', [1 1 60 40], 'Callback','astardemo');
end

