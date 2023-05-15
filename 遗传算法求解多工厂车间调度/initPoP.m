function pop=initPoP(popsize,F,n)
pop=cell(popsize,F);
for i=1:popsize
    r=randperm(n);
    for j=1:n
        t=randi(F);
        if isempty(pop{i,t})
            pop{i,t}=r(j);
        else
            pop{i,t}=[pop{i,t} r(j)];
        end
    end
    
end
end

