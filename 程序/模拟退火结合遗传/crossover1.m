function [ new_pop ] = crossover1( pop,crossover_rate,fismat,ub,lb)
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
        for k=1:4
            for j=1:length(ub)
                if childs(k,j) < lb(j)
                    childs(k,j)=lb(j);
                end
                if childs(k,j) > ub(j)
                    childs(k,j)=ub(j);
                end
            end
        end
        fit=cal_fitness(childs,fismat);
        [~,idx]=sort(fit,'descend');
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

