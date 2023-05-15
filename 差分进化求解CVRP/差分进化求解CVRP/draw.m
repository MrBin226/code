%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%画最优解
function draw(chrom,data)
    x=data(:,2);
    y=data(:,3);
    figure;
    hold on;
    route=decode(chrom);
    [~,m]=size(route);
    scatter(x,y,'r')
    for i=1:m
        plot([x(1),x(route{i}(1)+1)],[y(1),y(route{i}(1)+1)],'Color',[1 0 0]);
        plot([x(route{i}(end)+1),x(1)],[y(route{i}(end)+1),y(1)],'Color',[1 0 0]);
        for j=1:length(route{i})-1
            plot([x(route{i}(j)+1),x(route{i}(j+1)+1)],[y(route{i}(j)+1),y(route{i}(j+1)+1)],'Color',[1 0 0]);
        end
    end
    title('最优解示意图');
end