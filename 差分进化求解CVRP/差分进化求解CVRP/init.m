%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%初始化种群
function result =  init(np,cusnum,dist,demand,carnum,maxload)
    result=[];
    for i=1:np
        while 1
            result(i,:)=create(cusnum,dist,carnum);
            if test(decode(result(i,:)),demand,maxload)
                break;
            end
        end
    end
end