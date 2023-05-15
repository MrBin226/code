function [ new_pop ] = select( pop,fitness,N,D,M )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
if D <= N
    new_pop = championships( pop,fitness,N );
else
    new_pop = extremum_select( pop,fitness,N,D,M );
end
end

