function [flag] = including(m_node,first,last)
%�ж���ʼ���Ƿ�������ת�ڵ�
%   ��first���ڣ�last�����ڣ�flag=0
%   ��first�����ڣ�last���ڣ�flag=1
%   ��first���ڣ�last���ڣ�flag=2
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

