%% 计算种群的目标函数值
function ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len)
                     
% route=1:cusnum;
% G= part_length(route,dist);               %G为对每条不可行路径的惩罚权重
demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
NIND=size(Chrom,1);                         %种群数目
ObjV=zeros(NIND,1);                         %储存每个个体函数值
G=100;                                       %G为对每条不可行路径的惩罚权重
for i=1:NIND
    [VC,NV,~,violate_num,~]=decode(Chrom(i,:),cusnum,cap,demands,a,b,L,s,dist,len);
    [cost]=costFuction(VC,a,b,s,E,dist,demands,cap,TC1,TC2,c1,transport_time,NV);
    if violate_num == 0
        ObjV(i)=cost;
    else
        ObjV(i)=cost + G;
    end
%     ObjV(i)=NV+G*violate_cus;
end
end

