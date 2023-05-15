%% 
%这个函数的作用就是把输入的点作为父节点，然后进行拓展找到子节点，并且找到子节点的代价，并且把子节点距离终点的代价找到。
%函数的输出量中costs表示拓展的子节点到起始点的代价，heuristics表示拓展出来的点到终止点的距离大约是多少，posinds表示拓展出来的子节点
function [cost,heuristic,posinds] = findFValue(posind,costsofar,field,goalind,heuristicmethod)
    n = length(field);  % 获取矩阵的长度
    [currentpos(1) currentpos(2)] = ind2sub([n n],posind);   %将要进行拓展的点（也就是父节点）的索引值拓展成坐标值
    [goalpos(1) goalpos(2)] = ind2sub([n n],goalind);        %将终止点的索引值拓展成坐标值
    cost = Inf*ones(4,1); heuristic = Inf*ones(4,1); pos = ones(4,2); %将矩阵cost和heuristic初始化为4x1的无穷大值的矩阵，pos初始化为4x2的值为1的矩阵
    
    % 拓展方向一
    newx = currentpos(2) - 1; newy = currentpos(1);
    if newx > 0
      pos(1,:) = [newy newx];
      switch lower(heuristicmethod)
        case 'euclidean'
          heuristic(1) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
        case 'taxicab'
          heuristic(1) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
      end
      cost(1) = costsofar + field(newy,newx);
    end

    % 拓展方向二
    newx = currentpos(2) + 1; newy = currentpos(1);
    if newx <= n
      pos(2,:) = [newy newx];
      switch lower(heuristicmethod)
        case 'euclidean'
          heuristic(2) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
        case 'taxicab'
          heuristic(2) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
      end
      cost(2) = costsofar + field(newy,newx);
    end

    % 拓展方向三
    newx = currentpos(2); newy = currentpos(1)-1;
    if newy > 0
      pos(3,:) = [newy newx];
      switch lower(heuristicmethod)
        case 'euclidean'
          heuristic(3) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
        case 'taxicab'
          heuristic(3) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
      end
      cost(3) = costsofar + field(newy,newx);
    end

    % 拓展方向四
    newx = currentpos(2); newy = currentpos(1)+1;
    if newy <= n
      pos(4,:) = [newy newx];
      switch lower(heuristicmethod)
        case 'euclidean'
          heuristic(4) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
        case 'taxicab'
          heuristic(4) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);
      end
      cost(4) = costsofar + field(newy,newx);
    end
     posinds = sub2ind([n n],pos(:,1),pos(:,2)); % 将拓展出来的子节点的坐标值转换为索引值
end
