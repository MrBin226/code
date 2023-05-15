function [new_pop] = select(pop,fitness,SELECTRATE)
%二元锦标赛选择
[row,col]=size(pop);
num=round(row*SELECTRATE);
new_pop=zeros(num,col);
for i=1:num
    temp=randsample(1:row,2);
    if fitness(temp(1)) < fitness(temp(2))
        new_pop(i,:)=pop(temp(1),:);
    else
        new_pop(i,:)=pop(temp(2),:);
    end
end
end

