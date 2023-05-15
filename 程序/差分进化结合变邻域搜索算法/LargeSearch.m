
function result = LargeSearch(chromesome,len,order_num,E,C,order_data,shelve_data,due_time,t1,t2,weight_similarity)
result=zeros(size(chromesome));
for m=1:size(chromesome)
    chrom=chromesome(m,:);
    while 1
        removeCus=randperm(order_num,len);
        temp=chrom;
        for i = 1:length(removeCus)
            temp(temp==removeCus(i))=[];
        end
        temp=decode(temp);
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
            [val,tt]=min(T);
            if val > 0
                temp{end+1}=ind;
            else
                temp{tt}=[temp{tt} ind];
            end
        end
        while 1
            u_v=nchoosek(1:length(temp),2);
            for j=1:size(u_v,1)
                tempbat=[temp{u_v(j,1)} temp{u_v(j,2)}];
                temp_ba=unique(cell2mat(order_data(tempbat)'));
                temp_sh=get_order_shelve(temp_ba,shelve_data);
                t_start=t1*length(temp_sh)+t2*length(temp_ba);
                t_due=t_start-due_time(tempbat);
                t_due(t_due<0)=0;
                temp_ba1=unique(cell2mat(order_data(temp{u_v(j,1)})'));
                temp_sh1=get_order_shelve(temp_ba1,shelve_data);
                t_start1=t1*length(temp_sh1)+t2*length(temp_ba1);
                t_due1=t_start1-due_time(temp{u_v(j,1)});
                t_due1(t_due1<0)=0;
                temp_ba2=unique(cell2mat(order_data(temp{u_v(j,2)})'));
                temp_sh2=get_order_shelve(temp_ba2,shelve_data);
                t_start2=t1*length(temp_sh2)+t2*length(temp_ba2);
                t_due2=t_start2-due_time(temp{u_v(j,2)});
                t_due2(t_due2<0)=0;
                u_v(j,3)=sum(t_due)-sum(t_due1)-sum(t_due2);
            end
            [val,tt]=min(u_v(:,3));
            if val > 0 || length([temp{u_v(tt,1)} temp{u_v(tt,2)}]) > C
                break;
            else
                temp{u_v(tt,1)}=[temp{u_v(tt,1)} temp{u_v(tt,2)}];
                temp(u_v(tt,1))=[];
            end
        end
        order_length=cellfun(@length,temp);
        if isempty(find(order_length>C, 1))
            temp_chrome=[];
            for kk=1:length(temp)-1
                temp_chrome=[temp_chrome temp{kk} 0];
            end
            temp_chrome=[temp_chrome temp{end}];
            break;
        end
    end
    result(m,1:length(temp_chrome))=temp_chrome;
    result(m,:) = adjust_sol(result(m,:),C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data);
end
end