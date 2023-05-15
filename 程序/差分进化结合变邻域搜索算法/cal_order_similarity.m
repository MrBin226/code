function [order_similarity] = cal_order_similarity(order_data)
%计算订单相似度

order_similarity=zeros(length(order_data));
for i=1:length(order_data)-1
    for j=i+1:length(order_data)
        temp=length(intersect(order_data{i},order_data{j})) / ...
             length(union(order_data{i},order_data{j}));
        order_similarity(i,j)=temp;
        order_similarity(j,i)=temp;
    end
end

end

