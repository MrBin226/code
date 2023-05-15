%% 交叉
%输   入：
%           parentsPop       上一代种群
%           NUMPOP           种群大小
%           CROSSOVERRATE    交叉率
%           LENGTH           r和Q各自的基因长度
%输   出：
%           kidsPop          下一代种群
%
%% 
function kidsPop = crossover(parentsPop,NUMPOP,CROSSOVERRATE,LENGTH)
kidsPop = {[]};n = 1;
while size(kidsPop,2)<NUMPOP-size(parentsPop,2)
    %选择出交叉的父代和母代
    father = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    mother = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    %随机产生交叉位置（分别在r和Q的基因上产生一个随机位置）
    crossLocation1 = randperm(LENGTH(1),1);
    crossLocation2 = randperm(LENGTH(2),1)+LENGTH(1);
    %如果随机数比交叉率低，就杂交
    if rand<CROSSOVERRATE
        father(1,crossLocation1:LENGTH(1)) = mother(1,crossLocation1:LENGTH(1));
        father(1,crossLocation2:end) = mother(1,crossLocation2:end);
        kidsPop{n} = father;
        n = n+1;
    end
end