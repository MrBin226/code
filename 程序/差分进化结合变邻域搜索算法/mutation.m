function [V] = mutation(chromesome,F,order_num,batch_num,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data) 
%±äÒì²Ù×÷
V=zeros(size(chromesome));
popsize=size(chromesome,1);
for i=1:popsize
    while 1
        r=randperm(popsize,3);
        v_i=chromesome(r(1),:)+F*(chromesome(r(2),:)-chromesome(r(3),:));
        pos=find(v_i==0);
        if length(pos) < batch_num
            break
        end
    end
    loc=setdiff(1:length(v_i),pos,'stable');
    temp=v_i;
    temp(pos)=[];
    B = sort(temp);
    tem=unique(temp);
    new_temp=temp;
    for k=1:length(tem)
        new_temp(temp==tem(k))=find(B==tem(k));
    end
    new_temp(new_temp>order_num)=0;
    v_i(loc)=new_temp;
    v_i=adjust_sol(v_i,C,E,weight_similarity,order_data,t1,t2,due_time,shelve_data);
    V(i,:)=v_i;
end

end

