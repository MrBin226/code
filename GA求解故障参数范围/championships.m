function [ new_pop ] = championships( pop,fitness,N )
%二元锦标赛选择
%   此处显示详细说明
[m,n]=size(pop);
new_pop=zeros(N,n);
for k=1:N
    t = randperm(m,2);
    if fitness(t(1)) < fitness(t(2))
        new_pop(k,:) = pop(t(1),:);
    else
        new_pop(k,:) = pop(t(2),:);
    end
end
end

