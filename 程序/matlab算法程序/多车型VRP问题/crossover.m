function [new_pop_x,new_pop_y]=crossover(pop_x,pop_y,Pc,demand,vehicle_cap)
new_pop_x=zeros(size(pop_x));
new_pop_y=zeros(size(pop_y));
idx=randperm(size(pop_x,1));
pop_x=pop_x(idx,:);
pop_y=pop_y(idx,:);
for i=1:floor(size(pop_x,1)/2)
    if rand()<=Pc %½»²æ¸ÅÂÊPc
        [new_pop_x(i*2-1,:),new_pop_x(i*2,:)]=OX(pop_x(i*2-1,:),pop_x(i*2,:));
        [~,n1,~]=decode(pop_x(i*2-1,:),pop_y(i*2-1,:),demand,vehicle_cap);
        [~,n2,~]=decode(pop_x(i*2,:),pop_y(i*2,:),demand,vehicle_cap);
        r=randperm(min(n1,n2),1);
        new_pop_y(i*2-1,1:r)=pop_y(i*2-1,1:r);
        new_pop_y(i*2-1,r+1:end)=pop_y(i*2,r+1:end);
        new_pop_y(i*2,1:r)=pop_y(i*2,1:r);
        new_pop_y(i*2,r+1:end)=pop_y(i*2-1,r+1:end);
    else
        new_pop_x(i*2-1,:)=pop_x(i*2-1,:);
        new_pop_x(i*2,:)=pop_x(i*2,:);
        new_pop_y(i*2-1,:)=pop_y(i*2-1,:);
        new_pop_y(i*2,:)=pop_y(i*2,:);
    end
end
if 2*i~=size(pop_x,1)
    new_pop_x(end,:)=pop_x(end,:);
    new_pop_y(end,:)=pop_y(end,:);
end

end

