%% 计算一条路线的路径长度
function p_l= part_length(route,dist,origin_dis)
n=length(route);
p_l=0;
if n~=0
    for i=1:n
        if i==1
            p_l=p_l+origin_dis(route(i));
        else
            p_l=p_l+dist(route(i-1),route(i));
        end
    end
    p_l=p_l+origin_dis(route(end));
end
end