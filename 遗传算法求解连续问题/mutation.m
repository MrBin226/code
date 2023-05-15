function [new_pop] = mutation (pop,best_pop,first_pop,mutate_rate)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n]=size(pop);
new_pop=zeros(m,n);
for k=1:m
    if rand() < mutate_rate
        new_pop(k,:)=pop(k,:)+2*rand()*(best_pop-pop(k,:))+2*rand()*(first_pop-pop(k,:));
    else
        new_pop(k,:)=pop(k,:);
    end
%     for r=1:n
%         if rand() < mutation_rate
%             u=rand();
%             if u <= 0.5
%                 delta_1 = (pop(k,r)-minRealVal(r))/(maxRealVal(r)-minRealVal(r));
%                 delta=(2*u+(1-2*u)*(1-delta_1)^(N_m+1))^(1/(N_m+1));
%             else
%                 delta_2 = (maxRealVal(r)-pop(k,r))/(maxRealVal(r)-minRealVal(r));
%                 delta=1-(2*(1-u)+2*(u-0.5)*(1-delta_2)^(N_m+1))^(1/(N_m+1));
%             end
%             new_pop(k,r)=pop(k,r)+delta*(maxRealVal(r)-minRealVal(r));
%         else
%             new_pop(k,r)=pop(k,r);
%         end
%     end
end
end

