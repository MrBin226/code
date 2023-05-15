%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%计算目标值，车辆数*1000+路径长度
function result = calobj(chrom,dist,Demand,MAXLOAD)
    [r,~]=size(chrom);
    result=zeros(r,1);
for r1 =1:r
    route=decode(chrom(r1,:));
    [~,m]=size(route);
if ~test(route,Demand,MAXLOAD)
    result(r1)=result(r1)+10000;
end
sumDemand=0;
    for i=1:m
        result(r1)=result(r1)+dist(1,route{i}(1)+1)+dist(route{i}(end)+1,1);
        for j=1:length(route{i})-1
            result(r1)=result(r1)+dist(route{i}(j)+1,route{i}(j+1)+1);
        end
    end
    result(r1)=result(r1)+m*1000;
end
end