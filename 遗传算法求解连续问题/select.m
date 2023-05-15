function [new_pop, index] = select(pop,fitness,select_rate)
[m,n]=size(pop);
parentsize=floor(m*select_rate);
new_pop=zeros(parentsize,n);
index=zeros(parentsize,1);
[~,idx]=min(fitness);
new_pop(1,:)=pop(idx,:);
index(1)=idx;
for i=2:parentsize
    idx=randperm(m,2);
    if fitness(idx(1)) < fitness(idx(2))
        new_pop(i,:)=pop(idx(1),:);
        index(i)=idx(1);
    else
        new_pop(i,:)=pop(idx(2),:);
        index(i)=idx(2);
    end
end
end

