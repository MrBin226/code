clc;             %清除命令窗口的内容
clear all;       %清除工作空间的所有变量，函数，和MEX文件
close all;       %关闭所有的figure窗口

n = 20;   % 产生一个n x n的方格，修改此值可以修改生成图片的方格数
wallpercent = 0.4;  % 这个变量代表生成的障碍物占总方格数的比例 ，如0.5 表示障碍物占总格数的50%

[field, startposind, goalposind, costchart, fieldpointers] =initializeField(n,wallpercent);
createFigure(field,costchart,startposind,goalposind)




%% 
function [field, startposind, goalposind, costchart, fieldpointers] = ...
  initializeField(n,wallpercent)
    field = ones(n,n) + 10*rand(n,n);%生成一个n*n的单位矩阵+0到10范围内的一个随机数
    field(ind2sub([n n],ceil(n^2.*rand(n*n*wallpercent,1)))) = Inf;%向上取整
    % 随机生成起始点和终止点
    startposind = sub2ind([n,n],ceil(n.*rand),ceil(n.*rand));  %随机生成起始点的索引值
    goalposind = sub2ind([n,n],ceil(n.*rand),ceil(n.*rand));   %随机生成终止点的索引值
    field(startposind) = 0; field(goalposind) = 0;  %把矩阵中起始点和终止点处的值设为0
    
    costchart = NaN*ones(n,n);%生成一个nxn的矩阵costchart，每个元素都设为NaN。就是矩阵初始NaN无效数据
    costchart(startposind) = 0;%在矩阵costchart中将起始点位置处的值设为0
    
    % 生成元胞数组
    fieldpointers = cell(n,n);%生成元胞数组n*n
    fieldpointers{startposind} = 'S'; fieldpointers{goalposind} = 'G'; %将元胞数组的起始点的位置处设为 'S'，终止点处设为'G'
    fieldpointers(field==inf)={0};
    
   
end

%%

function axishandle = createFigure(field,costchart,startposind,goalposind)

      % 这个if..else结构的作用是判断如果没有打开的figure图，则按照相关设置创建一个figure图
      if isempty(gcbf)                                       %gcbf是当前返回图像的句柄，isempty(gcbf)假如gcbf为空的话，返回的值是1，假如gcbf为非空的话，返回的值是0
      figure('Position',[450 100 700 700], 'MenuBar','none');  %对创建的figure图像进行设置，设置其距离屏幕左侧的距离为450，距离屏幕下方的距离为50，长度和宽度都为700，并且关闭图像的菜单栏
      axes('position', [0.01 0.01 0.99 0.99]);               %设置坐标轴的位置，左下角的坐标设为0.01,0.01   右上角的坐标设为0.99 0.99  （可以认为figure图的左下角坐标为0 0   ，右上角坐标为1 1 ）
      else
      gcf; cla;   %gcf 返回当前 Figure 对象的句柄值，然后利用cla语句来清除它
      end
      
      n = length(field);  %获取矩阵的长度，并赋值给变量n
      field(field < Inf) = 0; %将fieid矩阵中的随机数（也就是没有障碍物的位置处）设为0
      pcolor(1:n+1,1:n+1,[field field(:,end); field(end,:) field(end,end)]);%多加了一个重复的（由n X n变为 n+1 X n+1 ）
 
      cmap = flipud(colormap('jet'));  %生成的cmap是一个256X3的矩阵，每一行的3个值都为0-1之间数，分别代表颜色组成的rgb值
      cmap(1,:) = zeros(3,1); cmap(end,:) = ones(3,1); %将矩阵cmap的第一行设为0 ，最后一行设为1
      colormap(flipud(cmap)); %进行颜色的倒转 
      hold on;
   
    axishandle = pcolor([1:n+1],[1:n+1],[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);  %将矩阵costchart进行拓展，插值着色后赋给axishandle
   
    [goalposy,goalposx] = ind2sub([n,n],goalposind);
    [startposy,startposx] = ind2sub([n,n],startposind);
    plot(goalposx+0.5,goalposy+0.5,'ys','MarkerSize',10,'LineWidth',6);
    plot(startposx+0.5,startposy+0.5,'go','MarkerSize',10,'LineWidth',6);
  
    uicontrol('Style','pushbutton','String','RE-DO', 'FontSize',12, ...
      'Position', [1 1 60 40], 'Callback','astardemo');
end

