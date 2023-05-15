%matlab初始化
function A()
% clc;             %清除命令窗口的内容
% clear all;       %清除工作空间的所有变量，函数，和MEX文件
% close all;       %关闭所有的figure窗口

%方格数及障碍物比例的设定
n = 20;   % 产生一个n x n的方格，修改此值可以修改生成图片的方格数
% 障碍物坐标
wall = [11:20,33:42,69:22:69+2*22,71:22:71+2*22,74:22:74+2*22,76:22:76+2*22,79:22:79+2*22,81:22:81+2*22,84:22:84+2*22,86:22:86+2*22,...
    157:22:157+2*22,159:22:159+2*22,162:22:162+2*22,164:22:164+2*22,167:22:167+2*22,169:22:169+2*22,172:22:172+2*22,174:22:174+2*22,...
    245:22:245+2*22,247:22:247+2*22,250:22:250+2*22,252:22:252+2*22,255:22:255+2*22,257:22:257+2*22,260:22:260+2*22,262:22:262+2*22,...
    333:22:333+2*22,335:22:335+2*22,338:22:338+2*22,340:22:340+2*22,343:22:343+2*22,345:22:345+2*22,348:22:348+2*22,350:22:350+2*22];
startposind = 65;  %起始点的索引值
goalposind = 177;  %目标点的索引值

%方格以及障碍物的创建
[field, startposind, goalposind, costchart, fieldpointers] =initializeField(n,wall,startposind,goalposind); %随机生成包含障碍物，起始点，终止点等信息的矩阵

% 路径规划中用到的一些矩阵的初始化
setOpen = [startposind]; setOpenCosts = [0]; setOpenHeuristics = [Inf];
setClosed = []; setClosedCosts = [];
movementdirections = {'R','L','D','U'};  %移动方向


% 这个函数用来随机生成环境，障碍物，起点，终点
axishandle = createFigure(field,costchart,startposind,goalposind);    %将随机生成的方格及障碍物的数据生成图像

%%

% 这个while循环是本程序的核心，利用循环进行迭代来寻找终止点
while ~max(ismember(setOpen,goalposind)) && ~isempty(setOpen)
    [temp, ii] = min(setOpenCosts + setOpenHeuristics);     %寻找拓展出来的最小值 
    
    %这个函数的作用就是把输入的点作为父节点，然后进行拓展找到子节点，并且找到子节点的代价，并且把子节点距离终点的代价找到
    [costs,heuristics,posinds] = findFValue(setOpen(ii),setOpenCosts(ii), field,goalposind,'euclidean');
 
  setClosed = [setClosed; setOpen(ii)];     % 将找出来的拓展出来的点中代价最小的那个点串到矩阵setClosed 中 
  setClosedCosts = [setClosedCosts; setOpenCosts(ii)];    % 将拓展出来的点中代价最小的那个点的代价串到矩阵setClosedCosts 中
  
  % 从setOpen中删除刚才放到矩阵setClosed中的那个点
  %如果这个点位于矩阵的内部
  if (ii > 1 && ii < length(setOpen))
    setOpen = [setOpen(1:ii-1); setOpen(ii+1:end)];
    setOpenCosts = [setOpenCosts(1:ii-1); setOpenCosts(ii+1:end)];
    setOpenHeuristics = [setOpenHeuristics(1:ii-1); setOpenHeuristics(ii+1:end)];
    
  %如果这个点位于矩阵第一行
  elseif (ii == 1)
    setOpen = setOpen(2:end);
    setOpenCosts = setOpenCosts(2:end);
    setOpenHeuristics = setOpenHeuristics(2:end);
    
  %如果这个点位于矩阵的最后一行
  else
    setOpen = setOpen(1:end-1);
    setOpenCosts = setOpenCosts(1:end-1);
    setOpenHeuristics = setOpenHeuristics(1:end-1);
  end
  
 %%  
  % 把拓展出来的点中符合要求的点放到setOpen 矩阵中，作为待选点
  for jj=1:length(posinds)
  
    if ~isinf(costs(jj))   % 判断该点（方格）处没有障碍物
        
      % 判断一下该点是否 已经存在于setOpen 矩阵或者setClosed 矩阵中
      % 如果我们要处理的拓展点既不在setOpen 矩阵，也不在setClosed 矩阵中
      if ~max([setClosed; setOpen] == posinds(jj))
        fieldpointers(posinds(jj)) = movementdirections(jj);
        costchart(posinds(jj)) = costs(jj);
        setOpen = [setOpen; posinds(jj)];
        setOpenCosts = [setOpenCosts; costs(jj)];
        setOpenHeuristics = [setOpenHeuristics; heuristics(jj)];
        
      % 如果我们要处理的拓展点已经在setOpen 矩阵中
      elseif max(setOpen == posinds(jj))
        I = find(setOpen == posinds(jj));
        % 如果通过目前的方法找到的这个点，比之前的方法好（代价小）就更新这个点
        if setOpenCosts(I) > costs(jj)
          costchart(setOpen(I)) = costs(jj);
          setOpenCosts(I) = costs(jj);
          setOpenHeuristics(I) = heuristics(jj);
          fieldpointers(setOpen(I)) = movementdirections(jj);
        end
        
        % 如果我们要处理的拓展点已经在setClosed 矩阵中
      else
        I = find(setClosed == posinds(jj));
        % 如果通过目前的方法找到的这个点，比之前的方法好（代价小）就更新这个点
        if setClosedCosts(I) > costs(jj)
          costchart(setClosed(I)) = costs(jj);
          setClosedCosts(I) = costs(jj);
          fieldpointers(setClosed(I)) = movementdirections(jj);
        end
      end
    end
  end
  
 %% 
  if isempty(setOpen) break; end
  set(axishandle,'CData',[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);
  set(gca,'CLim',[0 1.1*max(costchart(find(costchart < Inf)))]);
  drawnow;
  
end

%%

%调用findWayBack函数进行路径回溯，并绘制出路径曲线
if max(ismember(setOpen,goalposind))
  disp('路径已找到!');
  p = findWayBack(goalposind,fieldpointers); % 调用findWayBack函数进行路径回溯，将回溯结果放于矩阵P中
  plot(p(:,2)+0.5,p(:,1)+0.5,'Color',0.1*ones(3,1),'LineWidth',4);  %用 plot函数绘制路径曲线
  title(['路径长度为：',num2str(size(p,1)-1)])
  drawnow;
  drawnow;

elseif isempty(setOpen)
  disp('路径未找到!'); 
end


