function [flag] = including(m_node,first,last)
%判断起始点是否属于中转节点
%   若first属于，last不属于，flag=0
%   若first不属于，last属于，flag=1
%   若first属于，last属于，flag=2
if sum(ismember(m_node,first))==1
    if sum(ismember(m_node,last))==1
        flag=2;
    else
        flag=0;
    end
else
    flag=1;
end
end

