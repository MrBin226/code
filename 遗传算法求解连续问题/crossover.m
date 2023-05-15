function [ new_pop ] = crossover( pop,crossover_rate,wlength,lsource,system,rgb,xyz,lsources,st)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n]=size(pop);
new_pop=zeros(m,n);
offering_size=floor(m/2);
for i=1:offering_size
    a1 = pop(2*i-1,:);
    a2 = pop(2*i,:);
    if rand() < crossover_rate
        aa = rand();
        c1=a1+aa*(a2-a1);
        c2=a2+aa*(a2-a1);
        c3=a1-aa*(a2-a1);
        c4=a2-aa*(a2-a1);
        childs=[c1;c2;c3;c4];
        fit=cal_fitness(childs,wlength,lsource,system,rgb,xyz,lsources,st);
        [~,idx]=sort(fit);
        new_pop(2*i-1,:)=childs(idx(1));
        new_pop(2*i,:)=childs(idx(2));
%         new_pop(2*i-1,:)=aa*a1+(1-aa)*a2;
%         new_pop(2*i,:)=aa*a2+(1-aa)*a1;
    else
        new_pop(2*i-1,:)=a2;
        new_pop(2*i,:)=a1;
    end
end
if(mod(m,2))
   new_pop(m,:)=pop(m,:);
end
% for k=1:2:m
%     u = rand();
%     if u<=0.5
%         p=(2*u)^(1/(cross_n+1));
%     else
%         p=(1/(2-2*u))^(1/(cross_n+1));
%     end
%     t=randperm(m,2);
%     if k < m
%         new_pop(k,:)=(pop(t(1),:)+pop(t(2),:))/2 - (pop(t(2),:)-pop(t(1),:))*p/2;
%         new_pop(k+1,:)=(pop(t(1),:)+pop(t(2),:))/2 + (pop(t(2),:)-pop(t(1),:))*p/2;
%     else
%         new_pop(k,:)=(pop(t1,:)+pop(t2,:))/2 - (pop(t2,:)-pop(t1,:))*p/2;
%     end
% end
end

