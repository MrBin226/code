%% 计算每辆车离开当前路径上集配中心时的载货量、每辆车离开当前路径上每一点时的载货量
function [vl,dl]= vehicle_load(vehicles_customer,demands,dist)
n=size(vehicles_customer,1);                    %车辆总数
vl=zeros(n,1);                                          %每辆车离开当前路径上集配中心时的载货量、每辆车离开当前路径上每一点时的载货量
dl=zeros(n,1);
%% 先计算出每辆车在集配中心初始的装货总量
for i=1:n
    route=vehicles_customer{i};
    if isempty(route)
        vl(i)=0;
        dl(i)=0;
    else
        [Ld,d]= leave_load( route,demands,dist);
        vl(i)=Ld;
        dl(i)=d;
    end
end
end