function [ new_pop ] = crossover( pop,cross_n )
[m,n]=size(pop);
new_pop=zeros(m,n);
for k=1:2:m
    u = rand();
    if u<=0.5
        p=(2*u)^(1/(cross_n+1));
    else
        p=(1/(2-2*u))^(1/(cross_n+1));
    end
    t=randperm(m,2);
    if k < m
        new_pop(k,:)=(pop(t(1),:)+pop(t(2),:))/2 - (pop(t(2),:)-pop(t(1),:))*p/2;
        new_pop(k+1,:)=(pop(t(1),:)+pop(t(2),:))/2 + (pop(t(2),:)-pop(t(1),:))*p/2;
    else
        new_pop(k,:)=(pop(t1,:)+pop(t2,:))/2 - (pop(t2,:)-pop(t1,:))*p/2;
    end
end
end
