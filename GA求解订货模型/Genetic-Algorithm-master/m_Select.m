function parentPop=m_Select(matrixFitness,pop,SELECTRATE)
%% ѡ��
% ���룺matrixFitness--��Ӧ�Ⱦ���
%      pop--��ʼ��Ⱥ
% �����SELECTRATE--ѡ����

parentPop = zeros(size(pop,1),round(SELECTRATE*size(pop,2)));
[~,idx]=min(matrixFitness);
parentPop(:,1)=pop(:,idx); %������Ⱥ�����ŵĸ��嵽�Ӵ�
%��Ԫ����ѡ��
for n=2:round(SELECTRATE*size(pop,2))
    b = randperm(size(pop,2),2);
    if matrixFitness(b(1)) < matrixFitness(b(2))
        parentPop(:,n)=pop(:,b(1));
    else
        parentPop(:,n)=pop(:,b(2));
    end
end
end