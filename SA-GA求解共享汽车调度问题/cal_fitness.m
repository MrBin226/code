function [fitness] = cal_fitness(pop,data,dist,car_now)
[m,n]=size(pop);
fitness=zeros(m,1);
demand=data(:,end);
c1=0.5;
c2=5;
c3=10;
a=[0;0];
for i=1:m
    sol = pop(i,:);
    f1=0;
    f2=0;
    f3=0;
    for j=1:n
        if sol{j}~=a
            t=sol{j};
            f1=f1+dist(j,t(1))*1000;
        end
        if car_now(j)>=demand(j)
            f2=f2+car_now(j)-demand(j);
        else
            f3=f3+demand(j)-car_now(j);
        end
    end
    fitness(i)=f1*c1+0.7*f2*c2+0.3*f3*c3;
end
end

