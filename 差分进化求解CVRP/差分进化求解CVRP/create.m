%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%初始化个体，即产生初始解
function result= create(cusnum,dist,carnum)
    List=1:cusnum;
    A=randi([1 cusnum]);
    SList=[A];
    List(List==A)=[];
    dist=dist(2:end,2:end);
    dist(dist==0)=inf;
    while ~isempty(List)
        [~,T]=min(dist(:,SList(end)));
        dist(SList(end),:)=inf;
        dist(:,SList(end))=inf;
        SList=[SList T];
        List(List==T)=[];
    end

position=randperm(cusnum,carnum-1);
positionData=SList(position);
for i=1:carnum-1
    index = find(SList==positionData(i));
    if index==1
        SList=[0 SList];
    else
        SList=[SList(1:index-1) 0 SList(index:end)];
    end
end
result=SList;
end