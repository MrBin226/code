function [pop_x,pop_y]=initPoP(popsize,cusnum,vehicle_num,vehicle_model)
pop_x=zeros(popsize,cusnum);
all_vehicle_num=sum(vehicle_num);
pop_y=zeros(popsize,all_vehicle_num);
for i=1:popsize
    pop_x(i,:)=randperm(cusnum);
    idx=1:all_vehicle_num;
    for j=1:vehicle_model
        if j<vehicle_model
            tt=randperm(length(idx),vehicle_num(j));
            pop_y(i,idx(tt))=j;
            idx=setdiff(idx,tt);
        else
            pop_y(i,idx)=j;
        end
        
    end
end



end

