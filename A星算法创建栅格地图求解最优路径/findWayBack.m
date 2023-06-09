%findWayBack函数用来进行路径回溯，这个函数的输入参数是终止点goalposind和矩阵fieldpointers，输出参数是P
function p = findWayBack(goalposind,fieldpointers)

    n = length(fieldpointers);  % 获取环境的长度也就是n
    posind = goalposind;
    [py,px] = ind2sub([n,n],posind); % 将索引值posind转换为坐标值 [py,px]
    p = [py px];
    
    %利用while循环进行回溯，当我们回溯到起始点的时候停止，也就是在矩阵fieldpointers中找到S时停止
    while ~strcmp(fieldpointers{posind},'S')
      switch fieldpointers{posind}
          
        case 'L' % ’L’ 表示当前的点是由左边的点拓展出来的
          px = px - 1;
        case 'R' % ’R’ 表示当前的点是由右边的点拓展出来的
          px = px + 1;
        case 'U' % ’U’ 表示当前的点是由上面的点拓展出来的
          py = py - 1;
        case 'D' % ’D’ 表示当前的点是由下边的点拓展出来的
          py = py + 1;
      end
      p = [p; py px];
      posind = sub2ind([n n],py,px);% 将坐标值转换为索引值
    end
end
