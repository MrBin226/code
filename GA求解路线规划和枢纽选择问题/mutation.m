function [new_pop] = mutation(new_pop,VARIATIONRATE)
%µ•µ„±‰“Ï
[m,n]=size(new_pop);
for i=1:m
    randIndex=randperm(n,1);
    if rand()<VARIATIONRATE
        new_pop(i,randIndex)=~new_pop(i,randIndex);
    end
end

