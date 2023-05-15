function [new_chrome] = adjust_sol(chrome,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data)
%调整解，使其满足批次最大订单数量约束
new_chrome=zeros(size(chrome));
[order_batch] = decode(chrome);
order_length=cellfun(@length,order_batch);
idx=find(order_length>C);
if ~isempty(idx)
    while ~isempty(idx)
        u_v=order_batch{idx(1)}';
        for m=1:size(u_v,1)
            temp_ba=unique(cell2mat(order_data(setdiff(order_batch{idx(1)},u_v(m,1)))'));
            temp_sh=get_order_shelve(temp_ba,shelve_data);
            t_start=t1*length(temp_sh)+t2*length(temp_ba);
            t_due=t_start-due_time(setdiff(order_batch{idx(1)},u_v(m,1)));
            t_due(t_due<0)=0;
            u_v(m,2)=sum(t_due);
        end
        [~,ind]=min(u_v(:,2));
        ind=u_v(ind,1);
        order_batch{idx(1)}=setdiff(order_batch{idx(1)},ind,'stable');
        locat=find(order_length<E);
        T=[];
        if ~isempty(locat)
            temp_batch=cellfun(@(x) [x ind],order_batch(locat),'UniformOutput',0);
            for tb=1:length(temp_batch)
                temp_ba=unique(cell2mat(order_data(temp_batch{tb})'));
                temp_sh=get_order_shelve(temp_ba,shelve_data);
                t_start=t1*length(temp_sh)+t2*length(temp_ba);
                t_due=t_start-due_time(temp_batch{tb});
                t_due(t_due<0)=0;
                T(tb)=sum(t_due);
            end
            [val,tt]=min(T);
            if val > 0
                order_batch=[order_batch {ind}];
            else
                order_batch{locat(tt)}=[order_batch{locat(tt)} ind];
            end
        else
            locat=find(order_length<C);
            T=[];
            if ~isempty(locat)
                temp_batch=cellfun(@(x) [x ind],order_batch(locat),'UniformOutput',0);
                for tb=1:length(temp_batch)
                    temp_ba=unique(cell2mat(order_data(temp_batch{tb})'));
                    temp_sh=get_order_shelve(temp_ba,shelve_data);
                    t_start=t1*length(temp_sh)+t2*length(temp_ba);
                    t_due=t_start-due_time(temp_batch{tb});
                    t_due(t_due<0)=0;
                    T(tb)=sum(t_due);
                end
                [val,tt]=min(T);
                if val > 0
                    order_batch=[order_batch {ind}];
                else
                    order_batch{locat(tt)}=[order_batch{locat(tt)} ind];
                end
            else
                order_batch=[order_batch {ind}];
            end
        end
        order_length=cellfun(@length,order_batch);
        idx=find(order_length>C);
    end
    temp_chrome=[];
    for kk=1:length(order_batch)-1
        temp_chrome=[temp_chrome order_batch{kk} 0];
    end
    temp_chrome=[temp_chrome order_batch{end}];
    new_chrome(1:length(temp_chrome))=temp_chrome;
    new_chrome = adjust_sol(new_chrome,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data);
else
    idx=find(order_length<E);
    if ~isempty(idx)
        removeCus=cell2mat(order_batch(idx));
        temp=order_batch(order_length>=E);
        for i = 1:length(removeCus)
            ind=removeCus(i);
            temp_batch=cellfun(@(x) [x ind],temp,'UniformOutput',0);
            T=[];
            for tb=1:length(temp_batch)
                temp_ba=unique(cell2mat(order_data(temp_batch{tb})'));
                temp_sh=get_order_shelve(temp_ba,shelve_data);
                t_start=t1*length(temp_sh)+t2*length(temp_ba);
                t_due=t_start-due_time(temp_batch{tb});
                t_due(t_due<0)=0;
                T(tb)=sum(t_due);
            end
            [~,tt]=sort(T);
            leng=cellfun(@length,temp_batch);
            tt=setdiff(tt,find(leng>C));
            if isempty(tt)
                temp{end+1}=ind;
            else
                temp{tt(1)}=[temp{tt(1)} ind];
            end
        end
        temp_chrome=[];
        for kk=1:length(temp)-1
                temp_chrome=[temp_chrome temp{kk} 0];
        end
        temp_chrome=[temp_chrome temp{end}];
        new_chrome(1:length(temp_chrome))=temp_chrome;
    else
        temp_chrome=[];
        for kk=1:length(order_batch)-1
            temp_chrome=[temp_chrome order_batch{kk} 0];
        end
        temp_chrome=[temp_chrome order_batch{end}];
        new_chrome(1:length(temp_chrome))=temp_chrome;
    end
end

end

