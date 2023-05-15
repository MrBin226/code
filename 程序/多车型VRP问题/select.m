function [new_pop_x,new_pop_y]=select(pop_x,pop_y,fitness)
new_pop_x=zeros(size(pop_x));
new_pop_y=zeros(size(pop_y));
for i=1:size(pop_x,1)
    idx=randperm(size(pop_x,1),2);
    if fitness(idx(1))<fitness(idx(2))
        new_pop_x(i,:)=pop_x(idx(1),:);
        new_pop_y(i,:)=pop_y(idx(1),:);
    else
        new_pop_x(i,:)=pop_x(idx(2),:);
        new_pop_y(i,:)=pop_y(idx(2),:);
    end
end

end

