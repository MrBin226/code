%% ����
%��   �룺
%           parentsPop       ��һ����Ⱥ
%           NUMPOP           ��Ⱥ��С
%           CROSSOVERRATE    ������
%           LENGTH           r��Q���ԵĻ��򳤶�
%��   ����
%           kidsPop          ��һ����Ⱥ
%
%% 
function kidsPop = crossover(parentsPop,NUMPOP,CROSSOVERRATE,LENGTH)
kidsPop = {[]};n = 1;
while size(kidsPop,2)<NUMPOP-size(parentsPop,2)
    %ѡ�������ĸ�����ĸ��
    father = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    mother = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    %�����������λ�ã��ֱ���r��Q�Ļ����ϲ���һ�����λ�ã�
    crossLocation1 = randperm(LENGTH(1),1);
    crossLocation2 = randperm(LENGTH(2),1)+LENGTH(1);
    %���������Ƚ����ʵͣ����ӽ�
    if rand<CROSSOVERRATE
        father(1,crossLocation1:LENGTH(1)) = mother(1,crossLocation1:LENGTH(1));
        father(1,crossLocation2:end) = mother(1,crossLocation2:end);
        kidsPop{n} = father;
        n = n+1;
    end
end