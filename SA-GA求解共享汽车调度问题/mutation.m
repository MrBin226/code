function [new_pop]=mutation(pop,mutate_rate,data,dist)
[m,n]=size(pop);
new_pop=pop;
demand=data(:,end)';
cars=data(:,4)';
all_pos=1:n;
tt=all_pos(cars<demand);
for i=1:m
    sol=pop(i,:);
    idx=[];
    for k=1:n
        if sol{k}~=[0;0]
            idx=[idx;k];
        end
    end
    for j=1:length(idx)
        if rand() < mutate_rate
            [~,t]=min(dist(idx(j),tt));
            a = demand(tt(t))-cars(tt(t));
            b = cars(idx(j)) - demand(idx(j));
            temp=new_pop{i,idx(j)};
            s=randi(size(temp,2));
            temp(1,s)=t;
            if a<b
                temp(2,s)=a;
            else
                temp(2,s)=b;
            end
            new_pop{i,idx(j)}=temp;
        end
    end
end
end

