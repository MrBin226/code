function [new_pop] = cross(pop,CROSSOVERRATE)
%µ¥µã½»²æ
[m,n]=size(pop);
new_pop=zeros(m,n);
parent=pop(randperm(m),:);
for i=1:m
    if rand() < CROSSOVERRATE
        randindex=randperm(n,1);
        new_pop(i,:)=[pop(i,1:randindex) parent(i,randindex+1:end)];
    else
        new_pop(i,:)=pop(i,:);
    end
end
end

