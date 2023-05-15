function [pop] = initPop(pop_num,P_n)
%初始化种群
%   pop_num:种群大小
%   P_n:枢纽个数
%   pop:种群
pop=zeros(pop_num,P_n);
for i=1:pop_num
    pop(i,:)=round(rand(1,P_n));
end
end

