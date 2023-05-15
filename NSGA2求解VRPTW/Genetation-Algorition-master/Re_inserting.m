%% 将被移出的顾客重新插回所得到的新的车辆顾客分配方案
function [ ReIfvc,RTD ] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands,cap)

while ~isempty(removed)
    %% 最远插入启发式：将最小插入目标距离增量最大的元素找出来
    %     [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap );
    [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap );
    removed(removed==fv)=[];
    %% 根据插入点将元素插回到原始解中
    [rfvc,iTD]=insert(fv,fviv,fvip,fvC,rfvc,dist);
end
[ rfvc,~ ] = deal_vehicles_customer( rfvc );

ReIfvc=rfvc;
[ RTD,~ ] = travel_distance( ReIfvc,dist );
end

