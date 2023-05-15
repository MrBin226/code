%% 计算种群的目标函数值
function ObjV=calObj(Chrom,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time)
                     
% route=1:cusnum;
% G= part_length(route,dist);               %G为对每条不可行路径的惩罚权重
demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
NIND=size(Chrom,1);                         %种群数目
ObjV=zeros(NIND,2);                         %储存每个个体函数值
G=100;                                       %G为对每条不可行路径的惩罚权重
for i=1:NIND
    [VC,NV,~,violate_num,~]=decode(Chrom(i,:),cusnum,cap,demands,a,b,L,s,dist);
    [cost1,cost2]=costFuction(VC,a,b,s,E,dist,demands,cap,a1,a2,a3,C1k,C2k,transport_time,NV);
    if violate_num == 0
        ObjV(i,1)=cost1;
    else
        ObjV(i,1)=cost1 + G;
    end
    ObjV(i,2)=cost2;
%     ObjV(i)=NV+G*violate_cus;
end
end

