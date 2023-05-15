%% 计算当前解的成本函数
function [cost1,cost2]=costFuction(curr_vc,a,b,s,E,dist,demands,cap,a1,a2,a3,C1k,C2k,transport_time,NV)
[TD] = travel_distance(curr_vc,dist);
[w1,w2,w3]=violateTW(curr_vc,a,b,s,E,transport_time,demands,a3);
cost1=TD*C1k+NV*C2k+a1*w1+a2*w2;
cost2=w3 / sum(demands);
end

