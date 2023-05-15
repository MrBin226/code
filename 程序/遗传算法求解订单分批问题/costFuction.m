function cost=costFuction(VC,dist,origin_dis,demands,cap,alpha)
TD=travel_distance(VC,dist,origin_dis);
q=violateLoad(VC,demands,cap);
cost=TD+alpha*q;
end