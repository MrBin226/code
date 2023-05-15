%% 计算一条路线的路径长度
function [p_l,p_2,p_3]= part_length(route,dist)
n=length(route);
p_l=0;
p_2=0;
p_3=0;
if n~=0
    for i=1:n
        if i==1
            p_l=p_l+dist(1,route(i)+1);
        else
            p_l=p_l+dist(route(i-1)+1,route(i)+1);
        end
    end
    p_2=p_l;
    p_l=p_l+dist(route(end)+1,1);
    p_3=dist(route(end)+1,1);
end
end