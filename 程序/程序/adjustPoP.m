function [pop_y] = adjustPoP(pop_x,pop_y,vehicle_model,vehicle_num,demand,vehicle_cap)
for i=1:size(pop_y,1)
    [~,num,vc_model]=decode(pop_x(i,:),pop_y(i,:),demand,vehicle_cap);
    count=[];
    for j=1:vehicle_model
        count=[count,sum(ismember(vc_model,j))];
    end
    model=1:vehicle_model;
    tt=model(count<vehicle_num);
    model=model(count>vehicle_num);
    if ~isempty(model)
        for k=model
            idx=find(vc_model==k);
            cc=1;
            for r=tt
                for q=1:vehicle_cap(r)-count(r)
                    vc_model(idx(vehicle_num(k)+cc))=r;
                    if vehicle_num(k)+cc==length(idx)
                        break;
                    else
                        cc=cc+1;
                    end
                end
                if vehicle_num(k)+cc==length(idx)
                        break;
                end
            end
        end
    end
    pop_y(i,1:num)=vc_model;
end
end

