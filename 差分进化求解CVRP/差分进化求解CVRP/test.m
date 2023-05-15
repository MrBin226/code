%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%测试解是否满足载重约束，满足flag=1，否则flag=0
function flag = test(route,demand,maxload)
    flag=1;
    [~,n]=size(route);
    for i =1:n
    sum=0;
        for j =1:length(route{i})
            sum=sum+demand(route{i}(j)+1);
        end
        if sum>maxload
            flag=0;
            break;
        end
    end
end