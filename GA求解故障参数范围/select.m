function [ new_pop ] = select( pop,fitness,N,D,M )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if D <= N
    new_pop = championships( pop,fitness,N );
else
    new_pop = extremum_select( pop,fitness,N,D,M );
end
end

