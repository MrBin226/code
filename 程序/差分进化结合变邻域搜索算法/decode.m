function [order_batch] = decode(chrome)
%对染色体进行解码得到各批次订单
order_batch={};
temp=find(chrome==0);
count=1;  
for i=1:length(temp)
    if i==1                                         
        order=chrome(1:temp(i));               
        order(order==chrome(temp(i)))=[];    
    else
        order=chrome(temp(i-1):temp(i)); 
        order(order==chrome(temp(i-1)))=[];  
        order(order==chrome(temp(i)))=[];   
    end
    order_batch{count}=order;
    count=count+1; 
end
order=chrome(temp(end):end);                    
order(order==chrome(temp(end)))=[];
order_batch{count}=order;
order_batch(cellfun(@isempty,order_batch))=[];
end

