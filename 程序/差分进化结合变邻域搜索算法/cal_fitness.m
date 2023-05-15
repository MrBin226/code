function [fitness] = cal_fitness(chromesome,order_data,shelve_data,due_time,t1,t2,C,E)
%计算目标函数
fitness=zeros(size(chromesome,1),1);
for i=1:size(chromesome,1)
    [order_batch] = decode(chromesome(i,:));
    T=0;
    for k=1:length(order_batch)
        temp_batch=unique(cell2mat(order_data(order_batch{k})'));
        if length(order_batch{k})>C || length(order_batch{k})<E
            T=inf;
            break
        end
        temp_shelve=get_order_shelve(temp_batch,shelve_data);
        t_start=t1*length(temp_shelve)+t2*length(temp_batch);
        t_due=t_start-due_time(order_batch{k});
        t_due(t_due<0)=0;
        T=T+sum(t_due);
    end
    fitness(i)=T;
end

end

