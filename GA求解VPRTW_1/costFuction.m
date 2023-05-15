%% 计算当前解的成本函数
function [cost]=costFuction(curr_vc,a,b,s,E,dist,demands,cap,TC1,TC2,c1,transport_time,NV)
[TD] = travel_distance(curr_vc,dist);
[w1,w2]=violateTW(curr_vc,a,b,s,E,transport_time,demands);
cost=TD*TC2+NV*TC1+c1*w1+c1*w2;
end

