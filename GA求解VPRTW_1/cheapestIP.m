
%% 找出Removed数组中任一个元素的cheapest insertion point
%第一步：先找出满足时间窗约束和容量约束的所有插入点，再计算上述插入点的距离增量
%第二步：找出上述插入点距离增量最小的那个最佳插入点，并记录距离增量
function [civ,cip,C]= cheapestIP( rv,rfvc,L,a,b,s,dist,demands,cap,len)
NV=size(rfvc,1);              %所用车辆数
outcome=[];                 %存储每一个合理的插入点以及对应的距离增量 [车辆序号 插入点序号 距离增量]
for i=1:NV
    route=rfvc{i};          %其中的一条路径
    len=length(route);      %该路径上所经过顾客数量
    LB= part_length(route,dist);       %插入rv之前该条路径的距离
    %先将rv插入到route中的任何空隙，共(len+1)个,
    for j=1:len+1
        %将rv插入到集配中心后
        if j==1
            temp_r=[rv route];
            LA= part_length(temp_r,dist);       %插入rv之后该条路径的距离
            delta=LA-LB;                       %插入rv之后该条路径的距离增量
            [Ld,d]=leave_load( temp_r,demands,dist);
            %如果同时满足时间窗约束和容量约束，则该插入点合理，并记录下来
            if (Ld<=cap)&&(d<=len)
                outcome=[outcome;i j delta];
            end
            %将rv插入到集配中心前
        elseif j==len+1
            temp_r=[route rv];
            LA= part_length(temp_r,dist);       %插入rv之后该条路径的距离
            delta=LA-LB;                       %插入rv之后该条路径的距离增量
            [Ld,d]=leave_load( temp_r,demands,dist);
            %如果同时满足时间窗约束和容量约束，则该插入点合理，并记录下来
            if (Ld<=cap)&&(d<=len)
                outcome=[outcome;i j delta];
            end
            %将rv插入到顾客之间的任意空隙
        else
            temp_r=[route(1:j-1) rv route(j:end)];
            LA= part_length(temp_r,dist);       %插入rv之后该条路径的距离
            delta=LA-LB;                       %插入rv之后该条路径的距离增量
            [Ld,d]=leave_load( temp_r,demands,dist);
            %如果同时满足时间窗约束和容量约束，则该插入点合理，并记录下来
            if (Ld<=cap)&&(d<=len)
                outcome=[outcome;i j delta];
            end
        end
    end
end
%% 如果存在合理的插入点，则找出最优插入点，否在新增加一辆车运输
if ~isempty(outcome)
    addC=outcome(:,3);                          %每个插入点的距离增量
    [saC,sindex]=sort(addC);                    %将距离增量从小到达排序
    temp=outcome(sindex,:);                     %将距离增量从小到达排序后的[车辆序号 插入点序号 距离增量]
    civ=temp(1,1);                              %第一行即为最佳插入点以及对应的距离增量
    cip=temp(1,2);
    C=temp(1,3);
else
    civ=NV+1;
    cip=1;
    C=part_length(rv,dist);
end

end

