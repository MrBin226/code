function pop = initPop(popsize,varible_num,ub,lb)
pop=zeros(popsize,varible_num);

for i=1:varible_num
    ub_i=ub(i);
    lb_i=lb(i);
    pop(:,i)=rand(popsize,1).*(ub_i-lb_i)+lb_i;      
end

end

