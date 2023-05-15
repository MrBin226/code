function new_pop=crossover(pop,Pc)
new_pop=cell(length(pop),1);
for i=1:floor(length(pop)/2)
    parent1=pop{i*2-1};
    parent2=pop{i*2};
    if rand() < Pc
        child1=zeros(size(parent1));
        child2=zeros(size(parent2));
        idx=sort(randperm(size(parent1,2)-2,2)+1);
        child1(:,idx(1):idx(2))=parent1(:,idx(1):idx(2));
        seq1=setdiff(parent2(1,:),parent1(1,idx(1):idx(2)),'stable');
        index=setdiff(1:size(parent1,2),idx(1):idx(2));
        for tt=1:length(index)
            child1(:,index(tt))=parent2(:,parent2(1,:)==seq1(tt));
        end
        child2(:,idx(1):idx(2))=parent2(:,idx(1):idx(2));
        seq2=setdiff(parent1(1,:),parent2(1,idx(1):idx(2)),'stable');
        index=setdiff(1:size(parent1,2),idx(1):idx(2));
        for tt=1:length(index)
            child2(:,index(tt))=parent1(:,parent1(1,:)==seq2(tt));
        end
        new_pop{i*2-1}=child1;
        new_pop{i*2}=child2;
    else
        new_pop{i*2-1}=parent2;
        new_pop{i*2}=parent1;
    end
    if i==floor(length(pop)/2) && mod(length(pop),2)
        new_pop{end}=pop{end};
    end
end

end

