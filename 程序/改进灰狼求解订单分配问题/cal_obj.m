function [fitness,dis,time,pick_to_cargos] = cal_obj(pos,cargo_coord,cargo,pick_num,pick_coord,v,order,cargo_num,q,Tb)

cargo_of_pick=floor(pos);
fitness=0;
count=0;
dis=[];
for i=1:pick_num
    t2=cargo(cargo_of_pick==i);
    [~,idx]=sort(pos(cargo_of_pick==i));
    pick_to_cargo=t2(idx);
    pick_to_cargos{i}=pick_to_cargo;
    [~,temp]=ismember(pick_to_cargo,cargo_coord(:,1));
    distance=cal_distance([i,pick_to_cargo,i],[pick_coord(i,:);cargo_coord(temp,2:3);pick_coord(i,:)]);
    fitness=fitness+distance/v+100*max(sum(cargo_num(pick_to_cargo))-q,0);
    for j=1:length(order)
        if ~isempty(intersect(pick_to_cargo, order{j}))
            count=count+1;
        end
    end
    dis=[dis,distance];
end
fitness=fitness+count*Tb;
time=count*Tb;
end

