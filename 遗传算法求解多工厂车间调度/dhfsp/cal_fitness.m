function fitness=cal_fitness(pop,c,m_k,p_ijk)
[m,n]=size(pop);
fitness=zeros(m,1);
for i=1:m
    f_time=[];
    for j=1:n
        if ~isempty(pop{i,j})
            [~,time]=decode(pop{i,j},c,m_k{j},p_ijk{j});
            f_time=[f_time,time];
        end
    end
    fitness(i)=1/max(f_time);%取时间的倒数作为适应度函数
end

end

