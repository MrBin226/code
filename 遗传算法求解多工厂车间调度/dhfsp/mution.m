function new_pop=mution(pop,mutate_rate)
[m,n]=size(pop);
new_pop=cell(m,n);
for i=1:m
    if rand()<mutate_rate
        temp=pop(i,:);
        r=cellfun(@length,temp);
        [~,t1]=max(r);
        [~,t2]=min(r);
        if t1==t2
            new_pop(i,:)=pop(i,:);
        else
            temp{t2}=[temp{t2},temp{t1}(end)];
            temp{t1}=temp{t1}(1:end-1);
            new_pop(i,:)=temp;
        end
    else
        new_pop(i,:)=pop(i,:);
    end
end


end

