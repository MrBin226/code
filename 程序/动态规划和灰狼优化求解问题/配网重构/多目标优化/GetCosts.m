function costs=GetCosts(pop)

    nobj=numel(pop(1).Cost);  %返回数组的总数
    costs=reshape([pop.Cost],nobj,[]);%[]代表所有列

end

