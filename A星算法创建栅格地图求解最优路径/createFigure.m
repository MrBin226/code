%%
%利用随机生成的环境数据来进行环境的绘制
function axishandle = createFigure(field,costchart,startposind,goalposind)

      % 这个if..else结构的作用是判断如果没有打开的figure图，则按照相关设置创建一个figure图
      if isempty(gcbf)                                       %gcbf是当前返回图像的句柄，isempty(gcbf)假如gcbf为空的话，返回的值是1，假如gcbf为非空的话，返回的值是0
      figure('Position',[200 200 1000 700]);  %对创建的figure图像进行设置，设置其距离屏幕左侧的距离为200，距离屏幕下方的距离为200，长度为1000，宽度为700，并且关闭图像的菜单栏
      axes('position', [0 0 1 0.97]);               %设置坐标轴的位置，左下角的坐标设为0.01,0.01   右上角的坐标设为0.99 0.99  （可以认为figure图的左下角坐标为0 0   ，右上角坐标为1 1 ）
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
%        text(startposx+1,startposy+1,'start');
%        text(goalposx+1,goalposy+1,'end');
end