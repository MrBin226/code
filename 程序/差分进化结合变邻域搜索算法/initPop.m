%初始化种群
function [chromesome] = initPop(NP,chromosome_length,order_num,order_data,shelve_data,E,C,t1,t2,weight_similarity)

chromesome=zeros(NP,chromosome_length);

for i=1:NP
    chrome=cell(1,chromosome_length);
    r=randperm(order_num,1);
    chrome{1}=r;
    temp=setdiff(1:order_num,r);
    k=1;
    batch=[order_data{r}];
    t_start=0;
    num=randi([E,C],1);
    while ~isempty(temp)
        [~,pos]=sort(weight_similarity(r,:),'descend');
        pos=setdiff(pos,setdiff(1:order_num,temp),'stable');
        pos=pos(1);
        temp_batch=unique([batch, order_data{pos}]);
        temp_shelve=get_order_shelve(temp_batch,shelve_data);
        temp_t_start=t1*length(temp_shelve)+t2*length(temp_batch)+t_start;
%         if length(chrome{k})<C && isempty(find(due_time([chrome{k},pos])'+50 < temp_t_start, 1))
        if length(chrome{k})<num
            chrome{k}=[chrome{k},pos];
            batch=temp_batch;
            t_start=temp_t_start;
            r=pos;
            temp=setdiff(temp,r);
        else
            k=k+1;
            chrome{k}=pos;
            shelve=get_order_shelve(batch,shelve_data);
            t_start=t1*length(shelve)+t2*length(batch)+t_start;
            batch=[order_data{pos}];
            r=pos;
            temp=setdiff(temp,r);
            num=randi([E,C],1);
        end
    end
    chrome(cellfun(@isempty,chrome))=[];
        
    temp_chrome=[];
    for kk=1:length(chrome)-1
        temp_chrome=[temp_chrome chrome{kk} 0];
    end
    temp_chrome=[temp_chrome chrome{end}];
    chromesome(i,1:length(temp_chrome))=temp_chrome;
    
end

end

