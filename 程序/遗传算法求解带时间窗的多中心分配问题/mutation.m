function new_pop=mutation(pop,Pm,skill_num,service_people)
new_pop=cell(length(pop),1);
for i=1:length(pop)
    if rand()<Pm
        idx=randperm(size(pop{i},2),2);
        temp=pop{i};
        t=temp(:,idx(1));
        temp(:,idx(1))=temp(:,idx(2));
        temp(:,idx(2))=t;
        for k=1:skill_num
            u=find(temp(k+1,:));
            a=service_people{k};
            tt=u(randperm(length(u),1));
            temp(k+1,tt)=a(randperm(numel(a),1));
        end
        new_pop{i}=temp;
    else
        new_pop{i}=pop{i};
    end
end
end

