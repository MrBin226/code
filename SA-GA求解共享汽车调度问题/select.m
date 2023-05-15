function [new_pop,select_idx]=select(pop,fitness)
[m,n]=size(pop);
new_pop=cell(m,n);
select_idx=zeros(m,1);
for i=1:m
    idx=randperm(m,2);
    if fitness(idx(1)) < fitness(idx(2))
        new_pop(i,:)=pop(idx(1),:);
        select_idx(i)=idx(1);
    else
        new_pop(i,:)=pop(idx(2),:);
        select_idx(i)=idx(2);
    end
end
end

