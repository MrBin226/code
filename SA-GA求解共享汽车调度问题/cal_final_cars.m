function cars_now=cal_final_cars(pop,data)
cars_now=zeros(size(pop));
for i=1:size(pop,1)
    cars_now(i,:)=data(:,4);
    for j=1:size(pop,2)
        if pop{i,j}~=[0;0]
            sol=pop{i,j};
            for k=1:size(sol,2)
                cars_now(i,j)=cars_now(i,j)-sol(2,k);
                cars_now(i,sol(1,k))=cars_now(i,sol(1,k))+sol(2,k);
            end
        end
    end
end


end

