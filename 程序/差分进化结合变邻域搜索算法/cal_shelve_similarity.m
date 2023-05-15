function [shelve_similarity] = cal_shelve_similarity(order_data,shelve_data)
%计算货架的订单相似度

shelve_similarity=zeros(length(order_data));
for i=1:length(order_data)-1
    for j=i+1:length(order_data)
        s1=get_order_shelve(order_data{i},shelve_data);
        s2=get_order_shelve(order_data{j},shelve_data);
        temp=length(intersect(s1,s2)) / ...
             length(union(s1,s2));
        shelve_similarity(i,j)=temp;
        shelve_similarity(j,i)=temp;
    end
end
end

