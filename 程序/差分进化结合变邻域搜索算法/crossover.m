function [new_chromesome] = crossover(chromesome,V,CR,fitness,order_data,shelve_data,due_time,t1,t2,C,E,weight_similarity)
%顺序交叉，原个体与差分向量进行交叉
new_chromesome=zeros(size(chromesome));
for i=1:size(chromesome,1)
    fit=cal_fitness(V(i,:),order_data,shelve_data,due_time,t1,t2,C,E);
    if fit<fitness(i)
        new_chromesome(i,:)=V(i,:);
    else
        if rand()<CR
            a=chromesome(i,:);
            b=V(i,:);
            [a,b]=OX(a,b);
            a=adjust_sol(a,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data);
            b=adjust_sol(b,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data);
            fit_a=cal_fitness(a,order_data,shelve_data,due_time,t1,t2,C,E);
            fit_b=cal_fitness(b,order_data,shelve_data,due_time,t1,t2,C,E);
            if fit_a < fit_b
                new_chromesome(i,:)=a;
            else
                new_chromesome(i,:)=b;
            end
        else
            new_chromesome(i,:)=chromesome(i,:);
        end
    end

end

