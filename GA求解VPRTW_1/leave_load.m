%% 计算某一条路径上离开配送中心和顾客时的载货量
function [Ld,d]=leave_load( route,demands,dist)
n=length(route);                           
Ld=0;
d=0;
if n~=0
    for i=1:n
        if route(i)~=0
            if i==1
                d=dist(1,route(i)+1);
            else
                d=d+dist(route(i-1)+1,route(i)+1);
            end
            Ld=Ld+demands(route(i));
        end
    end
    d=d+dist(route(i)+1,1);
end
end

