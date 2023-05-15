%% 计算某一条路径上离开配送中心时的载货量
%输入route：               一条配送路线
%输入demands：             表示由配送中心运送到顾客的配送量
%输出Ld：                  表示车辆离开配送中心时的载货量
function Ld=leave_load(route,demands)
n=length(route);                            %配送路线经过顾客的总数量
Ld=0;                                       %初始车辆在配送中心时的装货量为0
if n~=0
    for i=1:n
        if route(i)~=0
            Ld=Ld+demands(route(i));
        end
    end
end
end