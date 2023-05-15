function parentPop=m_Select(matrixFitness,pop,SELECTRATE)
%% 选择
% 输入：matrixFitness--适应度矩阵
%      pop--初始种群
% 输出：SELECTRATE--选择率

parentPop = zeros(size(pop,1),round(SELECTRATE*size(pop,2)));
[~,idx]=min(matrixFitness);
parentPop(:,1)=pop(:,idx); %保留种群中最优的个体到子代
%二元锦标选择
for n=2:round(SELECTRATE*size(pop,2))
    b = randperm(size(pop,2),2);
    if matrixFitness(b(1)) < matrixFitness(b(2))
        parentPop(:,n)=pop(:,b(1));
    else
        parentPop(:,n)=pop(:,b(2));
    end
end
end