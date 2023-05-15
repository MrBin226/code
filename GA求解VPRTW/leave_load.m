%% 计算某一条路径上离开配送中心和顾客时的载货量
function Ld=leave_load( route,demands)
n=length(route);                           
Ld=0;                                    
if n~=0
    for i=1:n
        if route(i)~=0
            Ld=Ld+demands(route(i));
        end
    end
end
end

