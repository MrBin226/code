function [obj] = con_node(f)
%����������󣬵õ���ʼ�ڵ�Ͷ�Ӧ����ֹ�ڵ�
%   f:������
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

