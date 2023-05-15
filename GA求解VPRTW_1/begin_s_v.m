
%% 计算每辆车配送路线上在各个点开始服务的时间

function bsv= begin_s_v( vehicles_customer,s,transport_time)
n=size(vehicles_customer,1);
bsv=cell(n,1);
for i=1:n
    route=vehicles_customer{i};
    [bs,back]= begin_s( route,s,transport_time);
    bsv{i}=[bs,back];
end
end

