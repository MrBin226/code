%% 计算当前解的成本函数
%输入VC                       每辆车所经过的顾客
%输入dist                     距离矩阵
%输入demands                  各个顾客需求量
%输入cap                      车辆最大载货量
%输出cost                      成本函数 f=TD+alpha*q
function cost=costFuction(VC,dist,demands,cap,alpha)
TD=travel_distance(VC,dist);
q=violateLoad(VC,demands,cap);
cost=TD+alpha*q;
end