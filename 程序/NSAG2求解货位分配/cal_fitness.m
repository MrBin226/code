function [fitness] = cal_fitness(pop,layer,shelve_data,warehouse,order_data)
%UNTITLED2 计算目标函数值
%   此处显示详细说明
[m,~]=size(pop);
fitness=zeros(m,2);
x_end=((warehouse.v_c)^2/(warehouse.a_c)*warehouse.l);
y_end=((warehouse.v_s)^2/(warehouse.a_s)*warehouse.h);
for i=1:m
    chrome=pop(i,:);
    %% 计算第一个目标函数值
    f_t=0;
    % 计算tc和ts和全部时间
    for k=1:size(order_data,1)
        order=order_data{k};
        for j=1:length(order)
            if shelve_data(chrome(order(j)),1)<=x_end
                tc=2*sqrt(shelve_data(chrome(order(j)),1)*warehouse.l/warehouse.a_s);
            else
                tc=shelve_data(chrome(order(j)),1)*warehouse.l/warehouse.v_c+...
                      warehouse.v_c/warehouse.a_c;
            end
            if shelve_data(chrome(order(j)),3)<=y_end
                ts=2*sqrt(shelve_data(chrome(order(j)),3)*warehouse.h/warehouse.a_s);
            else
                ts=shelve_data(chrome(order(j)),3)*warehouse.h/warehouse.v_s+...
                      warehouse.v_s/warehouse.a_s;
            end
            if shelve_data(chrome(order(j)),3)>1
                f_t=f_t+(ts+2*(warehouse.t_t+warehouse.t_p+warehouse.t_sc));
            else
                f_t=f_t+(tc+4*warehouse.t_t+4*warehouse.l/warehouse.v_c+warehouse.t_p+warehouse.t_sc);
            end
        end
    end
    fitness(i,1)=f_t;
    %% 计算第二个目标函数值
    f2=0;
    for k=1:size(order_data,1)
        order=order_data{k};
        task_layer_num=zeros(layer(end),1);
        for j=1:length(order)
            task_layer_num(layer(chrome(order(j))))=task_layer_num(layer(chrome(order(j))))+1;
        end
        f2=f2+var(task_layer_num);
    end
    fitness(i,2)=f2;
end

end

