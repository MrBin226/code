function [order_shelve] = get_order_shelve(single_order,shelve_data)
%获取某个订单商品存放的货架集合
order_shelve=[];
for i=1:length(single_order)
    for k=1:length(shelve_data)
        if sum(ismember(shelve_data{k},single_order(i))) > 0
            order_shelve=[order_shelve, k];
            break;
        end
    end
end
order_shelve=unique(order_shelve);

end

