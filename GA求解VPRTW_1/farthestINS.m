%% 最远插入启发式：将最小插入目标距离增量最大的元素找出来
function [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap,len)
nr=length(removed);                   %被移出的顾客的数量
outcome=zeros(nr,3);
for i=1:nr
    %[车辆序号 插入点序号 距离增量]
    [civ,cip,C]= cheapestIP( removed(i),rfvc,L,a,b,s,dist,demands,cap,len);
    outcome(i,1)=civ;
    outcome(i,2)=cip;
    outcome(i,3)=C;
end
[mc,mc_index]=max(outcome(:,3));
temp=outcome(mc_index,:);
fviv=temp(1,1);
fvip=temp(1,2);
fvC=temp(1,3);
fv=removed(mc_index);

end

