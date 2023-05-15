function new_pop=select(pop,fitness)
[m,n]=size(pop);
new_pop=cell(m,n);
P=fitness/sum(fitness);
Pc=cumsum(P);%작생매쪽
for i=1:m
    target_index=find(Pc>=rand());
    new_pop(i,:)=pop(target_index(1),:);
end

end

