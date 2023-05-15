function [ fitness ] = cal_fitness( pop,f,M)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[m,~]=size(pop);
fitness=zeros(m,1);
for k = 1:m
    h_x=((pop(k,2)*pop(k,3)*pop(k,6))/(pop(k,1)*pop(k,2)*pop(k,6)+pop(k,1)*pop(k,3)*pop(k,4)*pop(k,5)*pop(k,8)*2*pi*f*1i+...
            pop(k,1)*pop(k,2)*pop(k,3)*pop(k,4)*pop(k,5)*pop(k,7)*pop(k,8)*(2*pi*f*1i)^2));
    fitness(k)=abs(h_x-M);
end
end

