%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%计算路径长度
function result=route_length(chrom,dist)
 [r,~]=size(chrom);
    result=zeros(r,1);
for r1 =1:r
    route=decode(chrom(r1,:));
    [~,m]=size(route);
    for i=1:m
%         demand=getWeight(route{i},Demand);
%         result(r1)=result(r1)+dist(1,route{i}(1)+1)*demand(1)+dist(route{i}(end)+1,1);
        result(r1)=result(r1)+dist(1,route{i}(1)+1)+dist(route{i}(end)+1,1);
        for j=1:length(route{i})-1
%             result(r1)=result(r1)+dist(route{i}(j)+1,route{i}(j+1)+1)*demand(j+1);
            result(r1)=result(r1)+dist(route{i}(j)+1,route{i}(j+1)+1);
        end
    end
end
end