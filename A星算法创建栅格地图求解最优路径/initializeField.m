%% 
%这个矩阵的作用就是随机生成环境，障碍物，起始点，终止点等
function [field, startposind, goalposind, costchart, fieldpointers] = initializeField(n,wall,startposind,goalposind)
    field = ones(n,n) + 10*rand(n,n);%生成一个n*n的单位矩阵+0到10范围内的一个随机数
    field(wall) = Inf;%把障碍物所在的位置设为INF
    field(startposind) = 0; field(goalposind) = 0;  %把矩阵中起始点和终止点处的值设为0
    
    costchart = NaN*ones(n,n);%生成一个nxn的矩阵costchart，每个元素都设为NaN。就是矩阵初始NaN无效数据
    costchart(startposind) = 0;%在矩阵costchart中将起始点位置处的值设为0
    
    % 生成元胞数组
    fieldpointers = cell(n,n);%生成元胞数组n*n
    fieldpointers{startposind} = 'S'; fieldpointers{goalposind} = 'G'; %将元胞数组的起始点的位置处设为 'S'，终止点处设为'G'
    fieldpointers(field==inf)={0};
    
   
end
% end of this function