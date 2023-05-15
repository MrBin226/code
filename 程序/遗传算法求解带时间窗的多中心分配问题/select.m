function new_pop=select(pop,fitness)
new_pop=cell(length(pop),1);
for i=1:length(pop)
    idx=randperm(length(pop),2);
    if fitness(idx(1))<fitness(idx(2))
        new_pop{i}=pop{idx(1)};
    else
        new_pop{i}=pop{idx(2)};
    end
end


end

