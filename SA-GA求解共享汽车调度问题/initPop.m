function [pop,car_now] = initPop(popsize,num,data)
pop=cell(popsize,num);
car_now=zeros(popsize,num);
for i=1:popsize
    demand=data(:,end);
    cars=data(:,4);
    randpos=randperm(num);
    if cars(randpos(1)) > demand(randpos(1))
        idx=data(~ismember(1:num,randpos(1)),1);
        tt=idx(cars(idx)<demand(idx));
        t=randperm(length(tt));
        a = demand(tt(t(1)))-cars(tt(t(1)));
        b = cars(randpos(1)) - demand(randpos(1));
        if a>b
            aa=[tt(t(1));b];
            cars(tt(t(1)))=cars(tt(t(1)))+b;
            cars(randpos(1))=cars(randpos(1))-b;
        else
            aa=[tt(t(1));a];
            cars(tt(t(1)))=cars(tt(t(1)))+a;
            cars(randpos(1))=cars(randpos(1))-a;
        end
    else
        aa=[0;0];
    end
    pop{i,randpos(1)}=aa;
    for j=2:num
         if cars(randpos(j)) > demand(randpos(j))
            idx=data(~ismember(1:num,randpos(j)),1);
            tt=idx(cars(idx)<demand(idx));
            t=randperm(length(tt));
            a = demand(tt(t(1)))-cars(tt(t(1)));
            b = cars(randpos(j)) - demand(randpos(j));
            if a>b
                aa=[tt(t(1));b];
                cars(tt(t(1)))=cars(tt(t(1)))+b;
                cars(randpos(j))=cars(randpos(j))-b;
            else
                aa=[tt(t(1));a];
                cars(tt(t(1)))=cars(tt(t(1)))+a;
                cars(randpos(j))=cars(randpos(j))-a;
            end
            if isempty(pop{i,randpos(j)})
                pop{i,randpos(j)}=aa;
            else
                pop{i,randpos(j)}={pop{i,randpos(j)};aa};
            end
        else
            aa=[0;0];
            if isempty(pop{i,randpos(j)})
                pop{i,randpos(j)}=aa;
            end
        end
    end
    car_now(i,:)=cars;
end
end

