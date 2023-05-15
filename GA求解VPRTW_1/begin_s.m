
%% 计算一条路线上车辆对顾客的开始服务时间
function [bs,back]= begin_s( route,s,transport_time )
n=length(route);                        %配送路线上经过顾客的总数量
bs=zeros(1,n);                          %车辆对顾客的开始服务时间


bs(1)=transport_time(1,route(1)+1);
for i=1:n
    if i~=1
        bs(i)=bs(i-1)+s(route(i-1))+transport_time(route(i-1)+1,route(i)+1);
    end
end
back=bs(end)+s(route(end))+transport_time(route(end)+1,1);

end

