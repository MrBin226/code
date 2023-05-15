%%
%����������ɵĻ������������л����Ļ���
function axishandle = createFigure(field,costchart,startposind,goalposind)

      % ���if..else�ṹ���������ж����û�д򿪵�figureͼ������������ô���һ��figureͼ
      if isempty(gcbf)                                       %gcbf�ǵ�ǰ����ͼ��ľ����isempty(gcbf)����gcbfΪ�յĻ������ص�ֵ��1������gcbfΪ�ǿյĻ������ص�ֵ��0
      figure('Position',[200 200 1000 700]);  %�Դ�����figureͼ��������ã������������Ļ���ľ���Ϊ200��������Ļ�·��ľ���Ϊ200������Ϊ1000�����Ϊ700�����ҹر�ͼ��Ĳ˵���
      axes('position', [0 0 1 0.97]);               %�����������λ�ã����½ǵ�������Ϊ0.01,0.01   ���Ͻǵ�������Ϊ0.99 0.99  ��������Ϊfigureͼ�����½�����Ϊ0 0   �����Ͻ�����Ϊ1 1 ��
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
%        text(startposx+1,startposy+1,'start');
%        text(goalposx+1,goalposy+1,'end');
end