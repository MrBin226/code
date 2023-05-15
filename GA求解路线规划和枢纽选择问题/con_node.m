function [obj] = con_node(f)
%根据需求矩阵，得到起始节点和对应的终止节点
%   f:需求量
node=size(f,1);
obj={};
for i=1:node
    end_node=[];
    for j=1:node
        if f(i,j)>0
            end_node=[end_node j];
        end
    end
    obj{i}=end_node;
end

