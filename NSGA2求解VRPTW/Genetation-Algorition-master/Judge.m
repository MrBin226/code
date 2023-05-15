%% 判断当前方案是否满足载重量约束，0表示违反约束，1表示满足全部约束
function flag=Judge(VC,cap,demands)
flag=1;                         %假设满足约束
NV=size(VC,1);                  %车辆使用数目
%% 计算每辆车的装载量
init_v=vehicle_load(VC,demands);

%% 遍历每条路径，一旦有一条路径不满足约束，flag=0
for i=1:NV
    if init_v(i)>cap
        flag=0;
        break
    end
end
end

