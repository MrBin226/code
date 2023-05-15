function fitness=cal_fitness(pop_x,pop_y,demand,dist,vehicle_cap,vehicle_start_cost,transport_cost)
[m,~]=size(pop_x);
fitness=zeros(m,1);
for i=1:m
    [VC,num,vc_model]=decode(pop_x(i,:),pop_y(i,:),demand,vehicle_cap);
    everyTD=travel_distance(VC,dist);
    for j=1:num
        fitness(i)=fitness(i)+everyTD(j)*transport_cost(vc_model(j))+vehicle_start_cost(vc_model(j));
    end
end


end

